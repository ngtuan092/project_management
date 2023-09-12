module ReportsHelper
  def report_stt counter
    counter + 1
  end

  def can_edit_delete_report report
    current_user.can_edit_delete_report? report
  end
end
