class GroupMonthAnalyzer < Patterns::Service
  include StatisticsGroupsHelper

  def initialize group, start_month_year, end_month_year
    @group = group
    @start_month_year = start_month_year
    @end_month_year = end_month_year
    @project_ids = Project.all.pluck(:id)
    # list {[project_id, month, year] => resource}
    @projects_resources = ProjectUserResource.total_all_project_month
    # list {[project_id, month, year] => value}
    @projects_values = ProjectFeature.total_all_project_month
    # total value for each project 1 + (1+ 2) + (1 + 2 + 3) ...
    # {project_id: total_value, ..
    @total_value = @project_ids.index_with 0
  end

  def call
    group_analyzer_months
  end

  private
  attr_reader :group, :start_month_year, :end_month_year, :total_value,
              :project_ids, :projects_values, :projects_resources

  def group_analyzer_months
    # return hash member, value, diff per month
    hash_out = {}
    # [[year, month], [year, month], [year, month], [year, month]]
    month_number_displayed(start_month_year, end_month_year).each do |ele|
      members, added_value = released_group_analyzer ele[1], ele[0]
      hash_out[ele.reverse.join "-"] = {members:, added_value:,
                                        diff: (added_value - members)
                                       .round(Settings.digits.length_2)}
    end
    hash_out[:total] = group_value_resources_months hash_out
    # {month_year: {members, added_value, diff}, ...
    # total: {members, added_value, diff}}
    hash_out
  end

  # calculator project value, resource total in months
  def group_value_resources_months group_months
    # sum all months of group
    members_total = group_months.values.reduce(0){|a, e| a + e[:members]}
                                .round(Settings.digits.length_2)
    values_total = group_months.values.reduce(0){|a, e| a + e[:added_value]}
                               .round(Settings.digits.length_2)
    # hash value type output
    # {total: {value, resource, diff}
    {members: members_total, added_value: values_total,
     diff: (values_total - members_total).round(Settings.digits.length_2)}
  end

  def released_group_analyzer month, year
    # list {project_id => group resource, ...}
    group_resources = group.total_resource_groups_month month, year
    # added_value
    # project1_value  * project1_group_resource / project1_resource + project2_
    added_value = 0
    project_ids.each do |project_id|
      added_value = project_added_value project_id, month, year,
                                        group_resources, added_value
    end
    # total member in month
    members = group.user_groups_month_ids(month, year).count
    [members, added_value.round(Settings.digits.length_2)]
  end

  def project_added_value project_id, month, year, group_resources, added_value
    # total_value current month [project_id] = 1 + 2 + 3 ...
    hash_key = [project_id, month, year]
    total_value[project_id] += projects_values[hash_key] || 0
    project_resources = projects_resources[hash_key]
    project_group_resources = group_resources[project_id] || 0
    if project_resources
      total_value[project_id] * project_group_resources / project_resources
    else
      0
    end + added_value
  end
end
