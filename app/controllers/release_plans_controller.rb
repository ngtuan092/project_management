class ReleasePlansController < ApplicationController
  before_action :logged_in_user, :find_release_plan, only: %i(edit update)
  before_action only: :update do
    check_valid_project edit_release_plan_url,
                        params.dig(:release_plan, :project_id)
  end

  def edit
    @projects = current_user.valid_projects_by_role
  end

  def update
    if @release_plan.update release_plan_params
      flash[:success] = t(".update_success")
      redirect_to root_url
    else
      @projects = current_user.valid_projects_by_role
      flash[:danger] = t(".update_danger")
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def release_plan_params
    params.require(:release_plan).permit ReleasePlan::UPDATE_ATTRS
  end

  def find_release_plan
    @release_plan = ReleasePlan.find_by id: params[:id]
    return if @release_plan

    redirect_to :root, flash: {warning: t(".release_plan_not_found")}
  end
end
