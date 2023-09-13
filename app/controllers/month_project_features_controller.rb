class MonthProjectFeaturesController < ApplicationController
  before_action :logged_in_user, :find_project, only: :index

  def index
    year, month = params[:month_year]&.split("-")
    month ||= Time.zone.now.month
    year ||= Time.zone.now.year
    @project_features = @project.project_features.filter_month(month)
                                .filter_year(year)
    respond_to do |format|
      format.html{render :index}
      format.turbo_stream
    end
  end
end
