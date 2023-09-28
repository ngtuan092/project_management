class ProjectSlackSettingsController < ApplicationController
  before_action :logged_in_user
  before_action :find_project, only: %i(new create)

  def new
    @project_slack_setting = ProjectSlackSetting.new
  end

  def create
    @project_slack_setting = ProjectSlackSetting.new pj_slack_setting_params
    if @project_slack_setting.save
      flash[:success] = t(".create_success")
      respond_to(&:turbo_stream)
    else
      flash[:danger] = t(".create_fail")
      render :new, status: :unprocessable_entity
    end
  end

  private
  def pj_slack_setting_params
    params.require(:project_slack_setting)
          .permit ProjectSlackSetting::PROJECT_SLACK_SETTING_PARAMS
  end
end
