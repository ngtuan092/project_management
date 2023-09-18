class ValueResourcesController < ApplicationController
  def index
    @projects = Project.filter_name(params[:name])
                       .filter_group(params[:group_id])
                       .filter_status(params[:status])
    @pagy, @project_pagys = pagy @projects,
                                 items: Settings.pagy.number_itemss_20
  end
end
