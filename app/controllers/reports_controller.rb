class ReportsController < ApplicationController
  before_action :logged_in_user, only: %i(create new)
  before_action only: :create do
    check_valid_project new_report_url,
                        params.dig(:report, :project_id)
  end

  def new
    @report = Report.new
    @projects = current_user.valid_projects_by_role
  end

  def create
    @report = current_user.reports.build report_params
    if @report.save
      flash[:success] = t ".create_success"
      # redirect to reports_path
      redirect_to root_path
    else
      @projects = current_user.valid_projects_by_role
      flash[:danger] = t ".create_fail"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def report_params
    params.require(:report).permit Report::UPDATE_ATTRS
  end
end
