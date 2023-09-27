module FormHelper
  def show_errors object, field_name
    return unless object.errors.any?

    return if object.errors.messages[field_name].blank?

    object.errors.messages[field_name].join(", ").capitalize
  end

  def invalid object, field_name
    "is-invalid" if object.errors.include?(field_name)
  end

  def date_field_value date
    date = date.to_date if date.instance_of?(String)
    date ||= Time.zone.now
    date.strftime Settings.date.format_date_field
  end
end
