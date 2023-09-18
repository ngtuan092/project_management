require "pagy/extras/bootstrap"

require "pagy/extras/i18n"
# Pagy::VARS[:page_param] = "page"
# Pagy::VARS[:params] = ->(params) { { page: (params.dig(params[:page_param], Pagy::VARS[:page_param]) || 1).to_i + Settings.pagy.number_items_10 } }
