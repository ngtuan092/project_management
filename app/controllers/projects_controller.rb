class ProjectsController < ApplicationController
  before_action :logged_in_user
  before_action :find_project, only: %i(show destroy edit update)
  before_action :check_role, only: %i(destroy edit update)

  add_breadcrumb I18n.t("breadcrumbs.projects"), :projects_path

  def index
    @projects = Project.filter_name(params[:name])
                       .filter_group(params[:group])
                       .filter_status(params[:status])
                       .includes(:group)
    @pagy, @projects = pagy @projects, items: Settings.pagy.number_items_10
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
    @pagy, @project_members = pagy @project.project_users.by_earliest_joined,
                                   items: Settings.pagy.number_items_10
    add_breadcrumb @project.name, project_path(@project)
  end

  def destroy
    if @project.reports.empty?
      if @project.destroy
        flash[:success] = t ".delete_success"
        redirect_to projects_path
      else
        flash[:danger] = t ".fail_delete"
        redirect_to root_path, status: :unprocessable_entity
      end
    else
      flash[:danger] = t ".delete_fail"
      redirect_to @project, status: :unprocessable_entity
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
end
