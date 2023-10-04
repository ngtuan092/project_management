module StatisticsResourcesHelper
  # convert hash to list resources tag
  def resource_hash_to_html hash, html_tag
    # get all resources value in hash
    out = hash.values.map{|perm| perm[:resource]}
    out.map! do |ele|
      content_tag html_tag.to_sym, ele
    end
    # EX td tag: <td>ele1</td><td>ele2</td><td></td><td></td>
    safe_join out
  end

  def resources_project_html project, start_month_year, end_month_year
    hash_month = ProjectMonthAnalyzer.call(project,
                                           start_month_year, end_month_year)
                                     .result
    resource_hash_to_html hash_month, :td
  end

  def resources_projects_html projects, start_month_year, end_month_year
    hash_month = ProjectsMonthSummaryAnalyzer.call(projects,
                                                   start_month_year,
                                                   end_month_year)
                                             .result
    resource_hash_to_html hash_month, :td
  end

  def start_month_field_value month_year_params
    return month_year_params if month_year_params

    date = Date.current.change(month: 1)
    date.strftime Settings.date.format_month_field
  end

  def month_number_displayed start_month_year, end_month_year
    start_date = convert_month_year_to_date start_month_year
    end_date = convert_month_year_to_date end_month_year
    if start_date > end_date ||
       (start_date.end_of_month > Date.current.end_of_month)
      return []
    end

    end_date = Date.current if end_date > Date.current
    (start_date..end_date).map{|d| [d.year, d.month]}.uniq
  end

  def resources_project_xlsx project, start_month_year, end_month_year
    hash_month = ProjectMonthAnalyzer.call(project,
                                           start_month_year, end_month_year)
                                     .result
    hash_month.values.map{|value| value[:resource]}
  end

  def resources_projects_xlsx projects, start_month_year, end_month_year
    hash_month = ProjectsMonthSummaryAnalyzer.call(projects,
                                                   start_month_year,
                                                   end_month_year)
                                             .result
    values_array = hash_month.values.flat_map{|value| value[:resource]}
    values_array.unshift I18n.t("value_resources.index.total")
  end

  def header_months_xlsx start_month_year, end_month_year
    header = []
    header << I18n.t("projects.index.name")

    month_number_displayed(start_month_year, end_month_year).each do |i|
      month = "#{i[1]} - #{i[0]}"
      header << "#{I18n.t('project_features.project_feature.month')} #{month}"
    end
    header << I18n.t("value_resources.index.total_year")
  end
end
