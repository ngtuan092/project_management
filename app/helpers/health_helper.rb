module HealthHelper
  def status_options
    ProjectHealthItem.statuses.keys.map do |status|
      [t("health.status.#{status}"), status]
    end
  end

  def project_options_for_select projects
    projects.map{|project| [project.name, project.id]}
  end
end
