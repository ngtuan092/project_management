class ValueResourcesController < ApplicationController
  def index
    @projects = Project.filter_name(params[:name])
                       .filter_group(params[:group_id])
                       .filter_status(params[:status])
    @pagy, @project_pagys = pagy @projects,
                                 items: Settings.pagy.number_items_20
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
