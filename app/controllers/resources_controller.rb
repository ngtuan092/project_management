class ResourcesController < ApplicationController
  before_action :logged_in_user

  def index
    @projects = Project.filter_name(params[:name])
                       .filter_date(params[:date])
    @pagy, @projects = pagy @projects, items: Settings.pagy.number_items_10
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
  end

  def create
    @project = Project.find_by id: project_user_resources_params["id"]
    if @project
      @project.assign_attributes(project_user_resources_params.except("id"))
      unless check_changed?
        flash.now[:danger] = t ".not_change"
        render :new, status: :unprocessable_entity
        return
      end
      update_project_user_resources
      create_success
    else
      flash.now[:danger] = t ".can_not_find_project"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def project_user_resources_params
    params.require(:project)
          .permit(
            Project::PROJECT_USER_RESOURCES_PARAMS
          )
  end

  def update_project_user_resources
    ProjectUserResource.transaction do
      @project.project_user_resources&.each do |project_user_resource|
        if check_destroy? project_user_resource.id
          project_user_resource.destroy
        else
          project_user_resource.save!
        end
      end
    end
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
end
