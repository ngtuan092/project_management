module ReportsHelper
  def can_edit_delete_report report
    current_user.can_edit_delete_report? report
  end
end
