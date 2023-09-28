class HealthItemsController < ApplicationController
  before_action :logged_in_user
  before_action :check_role
  before_action :find_health_item, only: %i(edit update destroy)
  before_action :can_delete_health_item?, only: :destroy

  add_breadcrumb I18n.t("breadcrumbs.checklist"), :health_items_path

  def index
    @pagy, @health_items = pagy HealthItem.enable_items
                                          .filter_name(params[:name])
                                          .by_recently_created,
                                items: Settings.pagy.number_items_10
  end

  def new
    @health_item = HealthItem.new
  end

  def create
    @health_item = HealthItem.new health_item_params
    if @health_item.save
      @pagy, @health_items = pagy HealthItem.enable_items.by_recently_created,
                                  items: Settings.pagy.number_items_10
      flash[:success] = t ".create_success"
      respond_to(&:turbo_stream)
    else
      flash.now[:danger] = t ".create_fail"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @health_item.update health_item_params
      @pagy, @health_items = pagy HealthItem.enable_items.by_recently_created,
                                  items: Settings.pagy.number_items_10
      flash[:success] = t ".update_success"
      respond_to(&:turbo_stream)
    else
      flash[:danger] = t ".update_fail"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @health_item.destroy
      flash[:success] = t ".delete_success"
      redirect_to health_items_path
    else
      flash[:danger] = t ".delete_fail"
      redirect_to health_items_path, status: :unprocessable_entity
    end
  end

  private
  def health_item_params
    params.require(:health_item).permit HealthItem::HEALTH_ITEM_PARAMS
  end

  def check_role
    return if current_user.can_modify_health_item?

    flash[:warning] = t ".cannot_modify"
    redirect_to projects_path
  end

  def can_delete_health_item?
    return if @health_item.can_destroy_health_item?

    flash[:danger] = t ".delete_fail_used_in_projects"
    redirect_to health_items_path, status: :unprocessable_entity
  end
end
