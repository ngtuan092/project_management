module ProjectFeaturesHelper
  def list_repeat_unit
    ProjectFeature.repeat_units.keys.map do |key|
      [t("project_features.project_feature.#{key}"), key]
    end
  end

  def have_permission_project_feature? project_feature
    current_user.can_modify_project_feature? project_feature
  end

  def project_feature_stt counter
    counter + 1
  end
end
