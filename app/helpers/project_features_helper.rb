module ProjectFeaturesHelper
  def list_repeat_unit
    ProjectFeature.repeat_units.keys.map do |key|
      [t("project_features.project_feature.#{key}"), key]
    end
  end
end
