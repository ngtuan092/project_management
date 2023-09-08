module ReleasePlansHelper
  def list_status
    ReleasePlan.is_releaseds.keys.map do |key|
      [t("release_plans.is_released.#{key}"), key]
    end
  end
end
