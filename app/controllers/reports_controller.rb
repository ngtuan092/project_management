class ReportsController < ApplicationController
  before_action :logged_in_user, only: %i(create new index destroy)
  before_action only: :create do
    check_valid_project new_report_url,
                        params.dig(:report, :project_id)
  end
  before_action :find_report, only: :destroy
  before_action :check_role, only: :destroy

  def index
    @reports = Report.filter_date(params[:date])
                     .filter_name_status(params[:name], params[:status])
    @pagy, @reports = pagy @reports, items: Settings.pagy.number_items_10
  end

  def new
    @report = Report.new
    @projects = current_user.valid_projects_by_role
  end

  def create
    @report = current_user.reports.build report_params
    if @report.save
      flash[:success] = t ".create_success"
      redirect_to reports_path
    else
      @projects = current_user.valid_projects_by_role
      flash[:danger] = t ".create_fail"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @report.destroy
      flash[:success] = t ".delete_success"
      redirect_to reports_url
    else
      flash[:danger] = t ".fail_delete"
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  private

  def report_params
    params.require(:report).permit Report::UPDATE_ATTRS
  end

  def check_role
    return if current_user.can_edit_delete_report? @report

    flash[:warning] = t ".cannot_delete"
    redirect_to reports_url
  end
end
