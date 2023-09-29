class HealthController < ApplicationController
  before_action :logged_in_user, :check_permission
  before_action :find_project, only: %i(edit update)
  before_action :validate_form, only: %i(create)

  add_breadcrumb I18n.t("breadcrumbs.checklist"), :health_items_path

  def new
    @health_items = HealthItem.enable_items
    add_breadcrumb t("breadcrumbs.new"), :new_health_path
  end

  def create
    create_project_health_items params
    flash[:success] = t(".create_success")
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t(".create_fail")
  ensure
    redirect_to project_path(params[:project_id])
  end

  def edit
    @not_check_items = HealthItem.unchecked_health_items @project.id
  end

  def update
    if @project.update health_item_params
      create_unchecked_health_items
      flash[:success] = t ".update_success"
      respond_to do |format|
        format.html{redirect_to @project}
        format.turbo_stream
      end
    else
      flash.now[:danger] = t(".update_fail")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def create_unchecked_health_items
    return if params.dig(:project, :health_items).blank?

    create_project_health_items params[:project]
  end

  def health_item_params
    params.require(:project).permit Project::PROJECT_HEALTH_ITEMS_PARAMS
  end

  def create_project_health_items param_values
    ActiveRecord::Base.transaction do
      param_values[:health_items].each do |element|
        note = element[1]
        attrs = {project_id: param_values[:project_id],
                 health_item_id: element[0],
                 note:,
                 status: ProjectHealthItem.statuses[note]}
        item = ProjectHealthItem.new attrs
        item.save!
      end
    end
  end

  def check_permission
    project = Project.find_by id: params[:project_id]
    return if project.blank?

    return if project && current_user.can_edit_delete_project?(project)

    flash[:warning] = t ".not_permission"
    redirect_to project_path project
  end

  def validate_form
    params.require(:project_id)
    params.require(:health_items)

    has_error = false
    params[:health_items].each do |element|
      if element[1].empty?
        has_error = true
        break
      end
    end

    return unless has_error

    flash[:warning] = t(".validate_filled")
    redirect_to new_health_path
  end
end
