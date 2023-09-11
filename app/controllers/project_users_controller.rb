class ProjectUsersController < ApplicationController
  before_action :logged_in_user, :find_project,
                only: %i(new create)
  before_action :check_permission, only: %i(new create)
  def new
    @project_user = ProjectUser.new
  end

  def create
    @project_user = ProjectUser.new project_user_params
    if @project_user.save
      flash[:success] = t "project_user.create_success"
      redirect_to project_path @project
    else
      flash.now[:danger] = t "project_user.create_fail"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def project_user_params
    params.require(:project_user).permit ProjectUser::UPDATE_ATTRS
  end

  def check_permission
    return if current_user.can_add_member? @project

    flash[:warning] = t ".not_permission"
    redirect_to project_path @project
  end
end
