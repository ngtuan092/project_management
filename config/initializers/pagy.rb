require "pagy/extras/bootstrap"

Pagy::I18n.load({locale: "vi", filepath: "config/locales/vi.yml"},
                {locale: "en", filepath: "config/locales/en.yml"})
# Pagy::VARS[:page_param] = "page"
# Pagy::VARS[:params] = ->(params) { { page: (params.dig(params[:page_param], Pagy::VARS[:page_param]) || 1).to_i + Settings.pagy.number_items_10 } }
