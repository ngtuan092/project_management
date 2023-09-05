module ProjectsHelper
  def status_select
    Project.statuses.map do |status, _id|
      [t("project.form.status.#{status}"), status]
    end
  end

  def environment_select
    ProjectEnvironment.environments.map do |environment, _id|
      [t("project.form.environment.#{environment}"), environment]
    end
  end
end
