module StatisticsValuesHelper
  def values_hash_to_html hash, html_tag
    out = hash.values.map{|perm| perm[:value]}
    out.map! do |ele|
      content_tag html_tag.to_sym, ele
    end
    safe_join out
  end

  def values_project_html project, start_month_year, end_month_year
    hash_month = project_month_service.call(project,
                                            start_month_year,
                                            end_month_year).result
    values_hash_to_html hash_month, :td
  end

  def values_projects_html projects, start_month_year, end_month_year
    hash_month = project_month_summary_service.call(projects,
                                                    start_month_year,
                                                    end_month_year).result
    values_hash_to_html hash_month, :td
  end

  def values_project_xlsx project, start_month_year, end_month_year
    hash_month = project_month_service.call(project,
                                            start_month_year,
                                            end_month_year).result
    hash_month.values.map{|value| value[:value]}
  end

  def values_projects_xlsx projects, start_month_year, end_month_year
    hash_month = project_month_summary_service.call(projects,
                                                    start_month_year,
                                                    end_month_year).result
    values_array = hash_month.values.flat_map{|value| value[:value]}
    values_array.unshift I18n.t("value_resources.index.total")
  end
end
