class HealthItemsController < ApplicationController
  before_action :logged_in_user
  before_action :check_role, only: %i(index)

  add_breadcrumb I18n.t("breadcrumbs.checklist"), :health_items_path

  def index
    @pagy, @health_items = pagy HealthItem.enable_items
                                          .filter_name(params[:name]),
                                items: Settings.pagy.number_items_10
  end

  private
  def check_role
    return if current_user.can_modify_health_item?

    flash[:warning] = t ".cannot_modify"
    redirect_to projects_path
  end
end
