class ProjectFeaturesController < ApplicationController
  before_action :logged_in_user, :find_project_feature, only: %i(edit update)
  before_action :check_role, only: :update
  def edit; end

  def update
    if @project_feature.update project_feature_params
      @project_features = @project_feature.project.project_features
                                          .where(month: @project_feature.month,
                                                 year: @project_feature.year)
      flash.now[:success] = t ".update_success"
      respond_to(&:turbo_stream)
    else
      render :edit, status: :unprocessable_entity
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
end
