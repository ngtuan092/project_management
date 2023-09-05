module FormHelper
  def show_errors object, field_name
    return unless object.errors.any?

    return if object.errors.messages[field_name].blank?

    object.errors.messages[field_name].join(", ").capitalize
  end

  def invalid object, field_name
    "is-invalid" if object.errors.include?(field_name)
  end
end
