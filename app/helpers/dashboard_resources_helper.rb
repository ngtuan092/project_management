module DashboardResourcesHelper
  def resource_project project, start_month_year, end_month_year
    hash_month = ProjectMonthAnalyzer.call(project, start_month_year,
                                           end_month_year).result
    hash_month.delete(:total)
    hash = {}
    hash_month.each do |key, value|
      hash[key] = value[:resource]
    end
    {name: project.name, data: hash}
  end

  def resources_chart projects, start_month_year, end_month_year
    projects.map do |project|
      resource_project(project, start_month_year, end_month_year)
    end
  end
end
