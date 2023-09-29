class MonthProjectFeaturesController < ApplicationController
  before_action :logged_in_user, :find_project, only: :index

  add_breadcrumb I18n.t("breadcrumbs.project_features"),
                 :project_features_path

  def index
    year, month = params[:month_year]&.split("-")
    month ||= Date.current.month
    year ||= Date.current.year
    @project_features = @project.project_features.filter_month(month)
                                .filter_year(year).by_recently_created
    add_breadcrumb "#{@project.name} (#{month}/#{year})"
    respond_to do |format|
      format.html{render :index}
      format.turbo_stream
    end
  end
end
