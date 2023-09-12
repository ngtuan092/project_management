class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  include FormHelper
  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash_logged_in_user_danger"
    redirect_to login_url, status: :see_other
  end

  def correct_user
    redirect_to(root_url, status: :see_other) unless current_user? @user
  end

  def find_project
    @project = Project.find_by id: params[:id] || params[:project_id]
    return if @project

    flash[:warning] = t "errors.project_not_found"
    redirect_to root_path
  end

  def find_report
    @report = Report.find_by id: params[:id]
    return if @report

    flash[:warning] = t "errors.report_not_found"
    redirect_to root_path
  end

  def check_valid_project redirect_url, project_id
    @project = Project.find_by id: project_id
    return if @project && current_user.can_edit_delete_project?(@project)

    flash[:danger] = t "errors.permission_update_delete_project"
    redirect_to redirect_url, status: :see_other
  end
end
