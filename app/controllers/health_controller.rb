class HealthController < ApplicationController
  before_action :logged_in_user, :check_permission
  before_action :validate_form, only: %i(create)

  add_breadcrumb I18n.t("breadcrumbs.checklist"), :health_items_path

  def new
    @health_items = HealthItem.enable_items
    add_breadcrumb t("breadcrumbs.new"), :new_health_path
  end

  def create
    create_project_health_items
    flash[:success] = t(".create_success")
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t(".create_fail")
  ensure
    redirect_to project_path(params[:project_id])
  end

  private
  def create_project_health_items
    ActiveRecord::Base.transaction do
      params[:health_items].each do |element|
        note = element[1]
        attrs = {project_id: params[:project_id], health_item_id: element[0],
                 note:, status: ProjectHealthItem.statuses[note]}
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
