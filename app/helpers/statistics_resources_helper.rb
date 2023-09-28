module StatisticsResourcesHelper
  def list_statuses_selected
    params[:status] || Project.statuses[:in_progress]
  end

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
end
