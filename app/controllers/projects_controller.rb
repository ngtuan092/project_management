class ProjectsController < ApplicationController
  before_action :logged_in_user
  before_action :find_project, only: %i(show destroy edit update)
  before_action :check_role, only: %i(destroy edit update)
  before_action :can_destroy_project?, only: :destroy

  add_breadcrumb I18n.t("breadcrumbs.projects"), :projects_path

  def index
    @projects = filtered_projects
    @pagy, @projects = pagy @projects, items: Settings.pagy.number_items_10

    respond_to do |format|
      format.html
      format.xlsx do
        date = Time.zone.now.strftime Settings.date.format
        header = "attachment; filename=#{date}_projects.xlsx"
        response.headers["Content-Disposition"] = header
      end
    end
  end

  def create
    @project = Project.new project_params.merge(
      customers: Customer.by_id(project_params[:customers])
    )
    if @project.save
      flash[:success] = t "project.create_success"
      redirect_to projects_path
    else
      flash[:danger] = t "project.create_fail"
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @project = Project.new
    add_breadcrumb t("breadcrumbs.new"), :new_project_path
  end

  def show
    @project_customers = @project.customers
    @pagy, @project_members = pagy @project.project_users.by_recently_joined,
                                   items: Settings.pagy.number_items_10
    add_breadcrumb @project.name, project_path(@project)
  end

  def destroy
    if @project.destroy
      flash[:success] = t ".delete_success"
      redirect_to projects_path
    else
      flash[:danger] = t ".fail_delete"
      redirect_to projects_path, status: :unprocessable_entity
    end
  end

  def edit
    add_breadcrumb @project.name, project_path(@project)
    add_breadcrumb t("breadcrumbs.edit"), :edit_project_path
  end

  def update
    if @project.update project_params.merge(
      customers: Customer.by_id(project_params[:customers])
    )
      flash[:success] = t(".update_success")
      redirect_to @project
    else
      flash[:danger] = t(".update_fail")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def project_params
    params.require(:project).permit Project::PROJECT_PARAMS
  end

  def filtered_projects
    projects = Project.includes(:group)
    projects = projects.filter_start_date(params[:start_date])
    projects = projects.filter_end_date(params[:end_date])
    projects = projects.filter_name(params[:name])
    projects = projects.filter_group(params[:group_id])
    projects = projects.filter_status(params[:status])
    projects.by_recently_created
  end

  def check_role
    action_to_message = {
      destroy: "cannot_delete",
      edit: "cannot_edit",
      update: "cannot_edit"
    }
    message_key = action_to_message[action_name.to_sym]

    return if current_user.can_edit_delete_project? @project

    flash[:warning] = t ".#{message_key}"
    redirect_to projects_path
  end

  def can_destroy_project?
    return if @project.can_delete_project?

    flash[:danger] = t ".delete_fail"
    redirect_to projects_path, status: :unprocessable_entity
  end
end
