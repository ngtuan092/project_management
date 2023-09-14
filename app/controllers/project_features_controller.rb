class ProjectFeaturesController < ApplicationController
  before_action :logged_in_user, :find_project_feature,
                only: %i(edit update destroy)
  before_action :check_role, :filtered_project_features,
                only: %i(update destroy)

  def index
    year, month = params[:month_year]&.split("-")
    month ||= Time.zone.now.month
    year ||= Time.zone.now.year
    @projects = Project.filter_features(month, year)
    @pagy, @projects = pagy @projects, items: Settings.pagy.number_items_10
  end

  def show
    year, month = params[:date]&.split("-")
    @project = Project.find(params[:id])
    @project_features = @project.project_features.filter_month(month)
                                .filter_year(year)
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
    return if current_user.can_modify_project_feature? @project_feature

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
  end
end
