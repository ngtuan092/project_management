class ProjectsController < ApplicationController
  before_action :logged_in_user, only: %i(create new index show)
  before_action :find_project, only: :show

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

  private
  def project_params
    params.require(:project).permit Project::PROJECT_PARAMS
  end

  def find_project
    @project = Project.find_by id: params[:id]
    return if @project

    redirect_to :root, flash: {warning: t(".project_not_found")}
  end
end
