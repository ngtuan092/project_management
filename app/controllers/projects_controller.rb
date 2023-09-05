class ProjectsController < ApplicationController
  before_action :logged_in_user, only: %i(create new index)

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

  private

  def project_params
    params.require(:project).permit Project::PROJECT_PARAMS
  end
end
