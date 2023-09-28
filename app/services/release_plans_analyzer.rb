class ReleasePlansAnalyzer < Patterns::Service
  def initialize release_plans
    @release_plans = release_plans
  end

  def call
    stat_release_plans
  end

  private
  attr_reader :release_plans

  # return release, released per month and year
  # {2023: {1 :{release, released}, 2: {}}, 2024: {1 :{}}}
  def stat_release_plans
    stats = create_hash_stats
    release_plans.each do |release_plan|
      year_release = release_plan.release_date.year
      month_release = release_plan.release_date.month
      stats[year_release][month_release][:release] += 1

      next unless release_plan.is_released_released?

      year_released = release_plan.released_at.year
      month_released = release_plan.released_at.month
      stats[year_released][month_released][:released] += 1
    end
    stats
  end

  def create_hash_stats
    Hash.new do |hash, key|
      hash[key] = Hash.new do |inner_hash, inner_key|
        inner_hash[inner_key] = {release: 0, released: 0}
      end
    end
  end
end
