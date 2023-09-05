class ProjectsController < ApplicationController
  before_action :logged_in_user, only: %i(create new)
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
    params.require(:project).permit(:name, :description, :status, :start_date,
                                    :end_date, :group_id, :language,
                                    :repository, :redmine,
                                    :project_folder, :customer_info,
                                    project_environments_attributes:
                                    [:id, :environment, :domain, :port,
                                     :ip_address, :web_server,
                                     :note, :_destroy])
  end
end
