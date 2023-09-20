class ValueResourcesController < ApplicationController
  add_breadcrumb I18n.t("breadcrumbs.statistical"), :value_resources_path

  def index
    @projects = Project.filter_name(params[:name])
                       .filter_group(params[:group_id])
                       .filter_status(params[:status])
                       .by_recently_created
    @pagy, @project_pagys = pagy @projects,
                                 items: Settings.pagy.number_items_10
    @year = params[:year] || Date.current.year
    respond
  end

  private

  def respond
    respond_to do |format|
      format.html{render :index}
      format.xlsx do
        date = Time.zone.now.strftime Settings.date.format
        header = "attachment; filename=#{date}_project_management.xlsx"
        response.headers["Content-Disposition"] = header
      end
    end
  end
end
