Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi|jp/ do
    root "dashboard#index"
  end
end
