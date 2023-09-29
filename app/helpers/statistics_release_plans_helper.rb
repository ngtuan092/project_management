module StatisticsReleasePlansHelper
  def list_year
    current_year = Date.current.year
    (current_year - 4..current_year + 1).to_a
  end

  def release_plans_chart release_plans, project_features, year
    stats = stats_release_plans release_plans, year
    release = {}
    released = {}
    stats.each do |key, value|
      month_string = "#{key} - #{year}"
      release[month_string] = value[:release]
      released[month_string] = value[:released]
    end

    [{name: t("release_plans.is_released.preparing"), data: release},
     {name: t("release_plans.is_released.released"), data: released},
     man_month_chart(project_features, year)]
  end

  def release_plans_by_status release_plans
    total = release_plans.count
    ReleasePlan.is_releaseds.map do |key, value|
      status_count = release_plans.where(is_released: key).count
      ratio = status_count / total.to_f
      percentage = (ratio *  100).round(Settings.digits.length_2)
      percentage = 0 if percentage.nan? || percentage.infinite?
      {key:, value:,
       percentage:,
       count: status_count}
    end
  end

  def man_month_chart project_features, year
    man_month = {}
    (1..12).each do |month|
      value = project_features.total_man_month_year(month, year)
      man_month["#{month} - #{year}"] = value
    end
    {name: t("statistics_release_plans.man_month"), data: man_month}
  end

  private

  def stats_release_plans release_plans, year
    stats = ReleasePlansAnalyzer.call(release_plans).result
    stats = stats[year.to_i]
    (1..12).each do |month|
      stats[month] ||= {release: 0, released: 0}
    end
    stats.sort_by{|y, _data| y}.to_h
  end
end
