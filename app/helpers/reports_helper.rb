module ReportsHelper
  def date_field_value report
    date = report&.date || Time.zone.now
    date.strftime Settings.date.format_date_field
  end
end
