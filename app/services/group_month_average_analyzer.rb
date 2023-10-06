class GroupMonthAverageAnalyzer < Patterns::Service
  include StatisticsGroupsHelper

  def initialize group, start_month_year, end_month_year, is_separately
    @group = group
    @start_month_year = start_month_year
    @end_month_year = end_month_year
    @is_separately = is_separately
    @project_ids = Project.all.pluck(:id)
    # list {[project_id, month, year] => resource}
    @projects_resources = ProjectUserResource.total_all_project_month
    # list {[project_id, month, year] => value}
    @projects_values = ProjectFeature.total_all_project_month
  end

  def call
    group_analyzer_months
  end

  private
  attr_reader :group, :start_month_year, :end_month_year, :total_value,
              :project_ids, :projects_values, :projects_resources,
              :is_separately

  # {month_year: {members, added_value, diff}, ...
  # total: {members, added_value, diff}}
  def group_analyzer_months
    average_prs = average_projects
    # [[year, month], [year, month], [year, month], [year, month]]
    hash_out = month_number_displayed(start_month_year,
                                      end_month_year).map do |y_m|
      year, month = y_m
      [[month, year].join("-"), group_analyzer_month(month, year, average_prs)]
    end.to_h
    hash_out[:total] = group_value_resources_months hash_out
    hash_out
  end

  # {members, added_value, diff}
  def group_analyzer_month month, year, average_prs
    # total member in month
    members = group.user_groups_month_ids(month, year).count
    # added value of group
    added_value = group.total_resource_groups_month(month,
                                                    year).map do |pr_id, grs|
      average_prs[pr_id] * grs
    end.sum.round(Settings.digits.length_2)
    {members:, added_value: added_value.to_f,
     diff: (added_value - members).round(Settings.digits.length_2)}
  end

  # calculator group value, resource total months
  # {members, added_value, diff}
  def group_value_resources_months group_months
    # sum all months of group
    members_total = group_months.values.reduce(0){|a, e| a + e[:members]}
                                .round(Settings.digits.length_2)
    values_total = group_months.values.reduce(0){|a, e| a + e[:added_value]}
                               .round(Settings.digits.length_2)
    {members: members_total, added_value: values_total,
     diff: (values_total - members_total).round(Settings.digits.length_2)}
  end

  # {project_id: {[month, year] => value, ...}}
  def value_projects_months
    # projects_values_totals[project_id] = month 1 + month 2 + ...
    # {project_id: total_value, ..}
    projects_values_totals = project_ids.index_with 0
    project_ids.map do |project_id|
      project_hash = month_number_displayed(start_month_year,
                                            end_month_year).map do |y_m|
        # {[month, year] => value, ...}
        year, month = y_m
        projects_values_totals[project_id] += projects_values[[project_id,
                                                              month, year]] || 0
        [[month, year], projects_values_totals[project_id]]
      end.to_h
      [project_id, project_hash]
    end.to_h
  end

  # {project_id: {[month, year] => value, ...}}
  def value_projects_months_separate
    project_ids.map do |project_id|
      # {[month, year] => value, ...}
      project_hash = month_number_displayed(start_month_year,
                                            end_month_year).map do |y_m|
        year, month = y_m
        [[month, year], projects_values[[project_id, month, year]] || 0]
      end.to_h
      [project_id, project_hash]
    end.to_h
  end

  # total value of projects all months
  # {project_id: total_value, ...}
  def value_projects_months_total
    value_projects_months_method = if is_separately
                                     value_projects_months_separate
                                   else
                                     value_projects_months
                                   end
    value_projects_months_method.transform_values do |months|
      months.values.sum
    end
  end

  # {project_id: {[month, year] => resource, ...}}
  def resource_projects_months
    project_ids.map do |project_id|
      # {[month, year] => resource, ...}
      project_hash = month_number_displayed(start_month_year,
                                            end_month_year).map do |y_m|
        year, month = y_m
        [[month, year], projects_resources[[project_id, month, year]] || 0]
      end.to_h
      [project_id, project_hash]
    end.to_h
  end

  # total resource of projects all months
  # {project_id: total_resource, ...}
  def resource_projects_months_total
    resource_projects_months.transform_values do |months|
      months.values.sum
    end
  end

  # {project_id: average, ...}
  def average_projects
    resource_pr_mts_total = resource_projects_months_total
    value_projects_months_total.map do |pr_id, value|
      average = if resource_pr_mts_total[pr_id].zero?
                  0
                else
                  value / resource_pr_mts_total[pr_id]
                end
      [pr_id, average]
    end.to_h
  end
end
