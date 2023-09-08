class ProjectsController < ApplicationController
  before_action :logged_in_user, only: %i(create new index show destroy)
  before_action :find_project, only: %i(show destroy)
  before_action :check_role, only: :destroy

  def index
    @projects = Project.filter_name(params[:name])
                       .filter_group(params[:group])
                       .filter_status(params[:status])
    @pagy, @projects = pagy @projects, items: Settings.pagy.number_items
  end

  def create
    @project = Project.new project_params
    if @project.save
      flash[:success] = t "project.create_success"
      redirect_to root_path
    else
      flash[:danger] = t "project.create_fail"
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @project = Project.new
  end

  def show
    @project_customers = @project.customers
    @pagy, @project_members = pagy @project.project_users.by_earliest_joined,
                                   items: Settings.digits.length_30
  end

  def destroy
    if @project.reports.empty?
      if @project.destroy
        flash[:success] = t ".delete_success"
        redirect_to projects_url
      else
        flash[:danger] = t ".fail_delete"
        redirect_to root_path, status: :unprocessable_entity
      end
    else
      flash[:danger] = t ".delete_fail"
      redirect_to @project, status: :unprocessable_entity
    end
  end

  private

  def project_params
    params.require(:project).permit Project::PROJECT_PARAMS
  end

  def find_project
    @project = Project.find_by id: params[:id]
    return if @project

    redirect_to :root, flash: {warning: t(".project_not_found")}
  end

  def check_role
    return if current_user.can_edit_delete_project? @project

    flash[:warning] = t ".cannot_delete"
    redirect_to projects_url
  end
end
