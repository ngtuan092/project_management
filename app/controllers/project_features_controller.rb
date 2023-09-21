class ProjectFeaturesController < ApplicationController
  before_action :logged_in_user, only: %i(new create edit update)
  before_action :find_project_feature, only: %i(edit update destroy)
  before_action :check_role, :filtered_project_features,
                only: %i(update destroy)
  before_action :find_project, only: :create

  add_breadcrumb I18n.t("breadcrumbs.project_features"), :project_features_path

  def index
    year, month = params[:month_year]&.split("-")
    month ||= Time.zone.now.month
    year ||= Time.zone.now.year
    @projects = Project.filter_features(month, year).by_recently_created
    @pagy, @projects = pagy @projects, items: Settings.pagy.number_items_10
  end

  def show
    year, month = params[:date]&.split("-")
    @project = Project.find(params[:id])
    @project_features = @project.project_features.filter_month(month)
                                .filter_year(year).by_recently_created
  end

  def edit; end

  def update
    if @project_feature.update project_feature_params
      flash.now[:success] = t ".update_success"
      respond_to(&:turbo_stream)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @project_feature.destroy
      flash.now[:success] = t ".delete_success"
      respond_to(&:turbo_stream)
    else
      flash[:danger] = t ".fail_delete"
      redirect_back fallback_location: root_path
    end
  end

  def new
    @project = Project.new
    @project.project_features.build
    add_breadcrumb t("breadcrumbs.new"), new_project_feature_path
  end

  def create
    if @project.save
      flash[:success] = t ".create_success"
      redirect_to project_features_path
    else
      @project = Project.new project_feature_params_create
      @project.valid?
      flash[:danger] = t ".create_fail"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def project_feature_params
    params.require(:project_feature)
          .permit ProjectFeature::PROJECT_FEATURE_PARAMS
  end

  def find_project_feature
    @project_feature = ProjectFeature.find_by id: params[:id]
    return if @project_feature

    flash[:warning] = t "errors.project_feature_not_found"
    redirect_to root_path
  end

  def check_role
    return if current_user.can_edit_delete_project? @project_feature.project

    flash[:warning] = t "errors.permission_modify_project_feature"
    month_year = [@project_feature.year, @project_feature.month].join("-")
    redirect_to project_month_project_features_url(@project_feature.project,
                                                   month_year:)
  end

  def filtered_project_features
    month = @project_feature.month
    year = @project_feature.year
    @project_features = @project_feature.project.project_features
                                        .filter_month(month)
                                        .filter_year(year)
                                        .by_recently_created
  end

  def project_feature_params_create
    project_feature_params = params.require(:project)
                                   .permit Project::PROJECT_FEATURE_PARAMS
    month_year = project_feature_params["month_year"]
    if Settings.month_year.regex.match? month_year
      date = Time.zone.parse("#{project_feature_params['month_year']}-01")
      month = date.month
      year = date.year
      project_feature_params["project_features_attributes"]
        &.values
        &.each do |feature_params|
        feature_params.merge!(month:, year:)
      end
    end
    project_feature_params
  end

  def redirect_if_no_features
    flash[:danger] = t ".provide_at_least_1_feature"
    redirect_to new_project_feature_path
  end

  def find_project
    project_id = project_feature_params_create["project_id"]
    @project = Project.find_by(id: project_id)
    if @project
      before_project_feature = @project.project_features.size
      @project.assign_attributes(project_feature_params_create
                                   .except("project_id"))
      after_project_feature = @project.project_features.size
      # need at least 1 feature
      redirect_if_no_features if before_project_feature == after_project_feature
    else
      flash.now[:danger] = t ".can_not_find_project"
      render :new, status: :unprocessable_entity
    end
  end
end
