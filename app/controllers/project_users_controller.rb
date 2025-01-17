class ProjectUsersController < ApplicationController
  before_action :logged_in_user, :find_project,
                only: %i(new create)
  before_action :logged_in_user, :find_project_user, only: %i(destroy)
  before_action :check_permission, only: %i(new create destroy)
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

  def destroy
    if @project_user.project_user_resources.any?
      flash[:warning] = t "projects.project_member.cannot_delete_member"
    else
      destroy_project_user
    end
    redirect_to project_path @project
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

  def find_project_user
    @project_user = ProjectUser.find_by id: params[:id]
    if @project_user
      @project = @project_user.project
    else
      flash[:warning] = t "not_found_user"
      redirect_to root_path
    end
  end

  def destroy_project_user
    if @project_user.destroy
      flash[:success] = t "projects.project_member.delete_member_success"
    else
      flash[:danger] = t "projects.project_member.delete_member_fail"
    end
  end
end
