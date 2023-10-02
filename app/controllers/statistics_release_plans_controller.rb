class StatisticsReleasePlansController < ApplicationController
  before_action :logged_in_user
  add_breadcrumb I18n.t("layouts.sidebar.list_statistic_release"),
                 :statistics_release_plans_path
  def index
    @release_plans = fetch_release_plans
    @project_features = fetch_project_features
  end

  private
  def fetch_release_plans
    ReleasePlan.filter_project(params[:project_id])
               .filter_group(params[:group_id])
               .filter_year(params[:year])
               .includes(:project)
  end

  def fetch_project_features
    ProjectFeature.filter_project_id(params[:project_id])
                  .filter_group(params[:group_id])
                  .filter_year(params[:year])
                  .includes(:project)
  end
end
