class ReleasePlansController < ApplicationController
  before_action :logged_in_user, only: %i(edit update index new show)
  before_action :find_release_plan, only: %i(edit update show)
  before_action only: :update do
    check_valid_project edit_release_plan_url,
                        params.dig(:release_plan, :project_id)
  end

  def index
    @release_plans = ReleasePlan.filter_date(params[:date])
                                .filter_name(params[:name])
                                .filter_status(params[:status])
    @pagy, @release_plans = pagy @release_plans,
                                 items: Settings.pagy.number_items_10
  end

  def new; end

  def show; end

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
end
