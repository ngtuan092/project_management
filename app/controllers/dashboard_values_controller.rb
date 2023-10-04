class DashboardValuesController < ApplicationController
  before_action :logged_in_user

  add_breadcrumb I18n.t("layouts.sidebar.dashboard_values"),
                 :dashboard_values_path

  def index
    @projects = Project.filter_project(params[:project_id])
                       .filter_group(params[:group_id])
                       .filter_status(params[:status])
                       .by_recently_created
    @pagy, @project_pagys = pagy @projects,
                                 items: Settings.pagy.number_items_10
  end
end
