class StatisticsGroupsController < ApplicationController
  before_action :logged_in_user

  add_breadcrumb I18n.t("layouts.sidebar.statistics_group"),
                 :statistics_groups_path

  def index
    @groups = Group.filter_group(params[:group_id]).by_earliest_created
    @pagy, @group_pagys = pagy @groups, items: Settings.pagy.number_items_10
  end
end
