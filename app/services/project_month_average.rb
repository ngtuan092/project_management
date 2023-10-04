class ProjectMonthAverage < Patterns::Service
  def initialize project_hash_out
    # {month_year: {value, resource, diff}, ...total: {value, resource, diff}}
    @project_hash_out = project_hash_out
  end

  def call
    project_month_average
  end

  private
  attr_reader :project_hash_out

  # {month_year: {value, resource, diff}, ...total: {value, resource, diff}}
  def project_month_average
    average_value = average_project
    return project_hash_out unless average_value.to_f.finite?

    project_hash_out.map do |m_y, hash_value|
      hash_value = hash_average_value hash_value, average_value
      [m_y, hash_value]
    end.to_h
  end

  def hash_average_value hash_value, average_project
    hash_value[:value] = (hash_value[:resource] * average_project)
                         .round(Settings.digits.length_2)
    hash_value[:diff] = (hash_value[:value] - hash_value[:resource])
                        .round(Settings.digits.length_2)
    hash_value
  end

  # {project_id: average, ...}
  def average_project
    project_hash_out[:total][:value] / project_hash_out[:total][:resource].to_f
  end
end
