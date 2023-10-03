class StatisticsValuesController < ApplicationController
  before_action :logged_in_user

  add_breadcrumb I18n.t("breadcrumbs.values"), :statistics_values_path

  def index
    @projects = Project.filter_project(params[:project_id])
                       .filter_group(params[:group_id])
                       .filter_status(params[:status])
                       .by_recently_created
    @pagy, @project_pagys = pagy @projects,
                                 items: Settings.pagy.number_items_10
    @start_month_year = params[:start_month_year]
    @end_month_year = params[:end_month_year]
    respond
  end

  private

  def respond
    respond_to do |format|
      format.html{render :index}
      format.xlsx do
        date = Time.zone.now.strftime Settings.date.format
        header = "attachment; filename=#{date}_statistic_values.xlsx"
        response.headers["Content-Disposition"] = header
      end
    end
  end
end
