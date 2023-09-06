module ProjectsHelper
  include FormHelper

  def list_group
    Group.pluck :name, :id
  end

  def list_status
    Project.statuses.map do |key, value|
      [t("projects.project.#{key}"), value]
    end
  end

  def status_select
    Project.statuses.keys.map do |status|
      [t("project.form.status.#{status}"), status]
    end
  end

  def environment_select
    ProjectEnvironment.environments.keys.map do |environment|
      [t("project.form.environment.#{environment}"), environment]
    end
  end
end
