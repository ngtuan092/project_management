class DashboardController < ApplicationController
  before_action :logged_in_user, only: :index
  def index
    @projects = Project.filter_name(params[:name])
                       .filter_group(params[:group_id])
                       .filter_status(params[:status])
  end
end
