module MonthProjectFeaturesHelper
  def month_field_value month_year_params
    return month_year_params if month_year_params

    date = Time.zone.now
    date.strftime Settings.date.format_month_field
  end

  def man_month_total project_features
    project_features.reduce(0){|a, e| a + e.man_month}.round(2)
  end

  def effort_hour_month_total project_features
    project_features.reduce(0){|a, e| a + e.effort_hour_month_save}.round(2)
  end
end
