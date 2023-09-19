module ValueResourcesHelper
  def year_field_value params_year
    params_year || Date.current.year
  end

  # convert hash to specific tag
  def value_resource_hash_to_html hash, html_tag
    # flatten all value, resource, diff, total to array
    out = hash.values.map(&:values).flatten
    out.map!{|ele| content_tag html_tag.to_sym, ele}
    # EX td tag: <td>ele1</td><td>ele2</td><td></td><td></td>
    safe_join out
  end

  def value_resources_project_html project, year
    hash_month = ProjectMonthAnalyzer.call(project, year).result
    value_resource_hash_to_html hash_month, :td
  end

  def value_resources_total_html projects, year
    hash_month = ProjectsMonthSummaryAnalyzer.call(projects, year).result
    value_resource_hash_to_html hash_month, :td
  end

  def month_number_displayed year
    year ||= Date.current.year
    return Date.current.month if year.to_i == Date.current.year

    return Settings.number.value_0 if year.to_i > Date.current.year

    Settings.digits.length_12
  end

  def value_resources_project_xlsx project, year
    hash_month = ProjectMonthAnalyzer.call(project, year).result
    hash_month.values.map(&:values).flatten
  end

  def value_resources_total_xlsx projects, year
    hash_month = ProjectsMonthSummaryAnalyzer.call(projects, year).result
    values_array = hash_month.values.map(&:values).flatten
    values_array.unshift I18n.t("value_resources.index.total")
  end

  def header_row_xlsx year
    header = []
    header << I18n.t("projects.index.name")
    month_number_displayed(year).times do
      header << I18n.t("value_resources.index.value")
      header << I18n.t("value_resources.index.resource")
      header << I18n.t("value_resources.index.diff")
    end
    header << I18n.t("value_resources.index.total_value_year",
                     month: month_number_displayed(year))
    header << I18n.t("value_resources.index.total_resource_year",
                     month: month_number_displayed(year))
    header << I18n.t("value_resources.index.total_diff_year",
                     month: month_number_displayed(year))
  end

  def header_month_xlsx year
    header = [""]
    month_number_displayed(year).times do |i|
      header << "#{I18n.t('project_features.project_feature.month')} #{i + 1}"
      header << nil
      header << nil
    end
    header << I18n.t("value_resources.index.total_year")
  end
end
