class ResourcesController < ApplicationController
  before_action :logged_in_user
  add_breadcrumb I18n.t("breadcrumbs.resources"), :resources_path
  before_action :find_project, only: :show

  def index
    @year, @month = params[:month_year]&.split("-")
    @all_projects = filtered_projects
    @pagy, @projects = pagy @all_projects, items: Settings.pagy.number_items_10

    respond
  end

  def show
    @month = params[:month]
    @year = params[:year]
    @pagy, @project_user_resources = pagy(
      @project.project_user_resources
              .filter_month(@month)
              .filter_year(@year)
              .sorted_by_month_and_year,
      items: Settings.pagy.number_items_10
    )
  end

  def new
    if params["project_id"] && params["month_year"]
      find_project
      date = Date.parse("#{params['month_year']}-1")
      @month = date.month
      @year = date.year
    else
      @project = Project.new
    end
    add_breadcrumb t("breadcrumbs.new"), new_resource_path
  end

  def create
    @project = Project.find_by id: project_user_resources_params["id"]
    if @project
      @project.assign_attributes(project_user_resources_params.except("id"))
      unless check_changed?
        resolve_not_change
        return
      end
      create_success if update_project_user_resources_success?
    else
      flash.now[:danger] = t ".can_not_find_project"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def filtered_projects
    Project.filter_name(params[:name])
           .filter_resources(@month, @year)
           .by_recently_created
  end

  def project_user_resources_params
    params.require(:project)
          .permit(
            Project::PROJECT_USER_RESOURCES_PARAMS
          )
  end

  def update_project_user_resources_success?
    ProjectUserResource.transaction do
      @project.project_user_resources&.each do |project_user_resource|
        if check_destroy? project_user_resource.id
          project_user_resource.destroy
        elsif project_user_resource.changed?
          project_user_resource.save!
        end
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    create_errors e
    false
  end

  def check_destroy? id
    project_user_resources_params["project_user_resources_attributes"]
      &.each do |_key, project_user_resource|
      if project_user_resource["id"] == id.to_s &&
         project_user_resource["_destroy"] ==
         Settings.check_destroy.destroy_true
        return true
      end
    end
    false
  end

  def check_changed?
    @project.project_user_resources&.each do |project_user_resource|
      if project_user_resource.changed? ||
         check_destroy?(project_user_resource.id)
        return true
      end
    end
    false
  end

  def create_success
    flash[:success] = t ".update_success"
    redirect_to resources_path
  end

  def create_errors errors
    error_messages = errors.record.errors.full_messages
    error_messages.each do |message|
      flash[:danger] = message
    end
    month_year = params["month_year"]
    project_id = params["project_id"]
    redirect_to new_resource_path(month_year:, project_id:),
                status: :unprocessable_entity
  end

  def resolve_not_change
    flash[:danger] = t ".not_change"
    month_year = params["month_year"]
    project_id = params["project_id"]
    redirect_to new_resource_path(month_year:, project_id:),
                status: :unprocessable_entity
  end

  def respond
    respond_to do |format|
      format.html{render :index}
      format.xlsx do
        date = Time.zone.now.strftime Settings.date.format
        header = "attachment; filename=#{date}_resources.xlsx"
        response.headers["Content-Disposition"] = header
      end
    end
  end
end
