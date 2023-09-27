class StatisticsReleasePlansController < ApplicationController
  before_action :logged_in_user

  def index
    @release_plans = ReleasePlan.filter_project(params[:project_id])
                                .filter_group(params[:group_id])
                                .includes(:project)
  end
end
