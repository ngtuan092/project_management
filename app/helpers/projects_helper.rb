module ProjectsHelper
  def list_group
    Group.pluck :name, :id
  end

  def list_status
    Project.statuses.map do |key, value|
      [t("projects.project.#{key}"), value]
    end
  end
end
