class StatisticsResourcesController < ApplicationController
  before_action :logged_in_user

  add_breadcrumb I18n.t("layouts.sidebar.statistics_resources"),
                 :statistics_resources_path

  def index
    @projects = Project.filter_project(params[:project_id])
                       .filter_group(params[:group_id])
                       .filter_status(list_statuses_selected)
                       .by_recently_created
    @pagy, @project_pagys = pagy @projects,
                                 items: Settings.pagy.number_items_10
  end
end
