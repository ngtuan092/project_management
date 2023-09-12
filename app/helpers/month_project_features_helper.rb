module MonthProjectFeaturesHelper
  def month_field_value month_year_params
    return month_year_params if month_year_params

    date = Time.zone.now
    date.strftime Settings.date.format_month_field
  end

  def effort_hour_month_save project_feature
    total_hour = project_feature.effort_saved * project_feature.repeat_time
    case project_feature.repeat_unit.to_sym
    when :day then total_hour * 22
    when :week then total_hour * 4
    when :month then total_hour
    when :quarter then total_hour / 4
    when :half_a_year then total_hour / 6
    when :year then total_hour / 12
    else 0 end
  end

  def man_month_total project_features
    project_features.reduce(0){|a, e| a + e.man_month}.round(2)
  end

  def effort_hour_month_total project_features
    project_features.reduce(0){|a, e| a + effort_hour_month_save(e)}.round(2)
  end
end
