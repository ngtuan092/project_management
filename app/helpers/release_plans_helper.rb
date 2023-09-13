module ReleasePlansHelper
  def list_status
    ReleasePlan.is_releaseds.keys.map do |key|
      [t("release_plans.is_released.#{key}"), key]
    end
  end

  def release_plan_stt counter
    counter + 1
  end

  def can_edit_delete_release_plan release_plan
    current_user.can_edit_delete_release_plan? release_plan
  end
end
