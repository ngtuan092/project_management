module ApplicationHelper
  include Pagy::Frontend

  def format_date date
    date&.strftime Settings.date.format
  end

  def current_locale
    I18n.locale.to_s
  end

  def full_title page_title
    base_title = t "application.project_management"
    page_title.empty? ? base_title : [page_title, base_title].join(" | ")
  end

  def sequence_number counter, offset
    counter + 1 + offset
  end

  def active_class_for_url url
    "active" if request.path == url
  end

  def boolean_params params_name
    params[params_name.to_sym].present? && params[params_name.to_sym] == "1"
  end
end
