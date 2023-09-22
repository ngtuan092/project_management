module HealthHelper
  def status_options
    ProjectHealthItem.statuses.keys.map do |status|
      [t("health.status.#{status}"), status]
    end
  end

  def list_project
    Project.without_health_items.pluck :name, :id
  end
end
