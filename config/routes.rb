Rails.application.routes.draw do
  root "home#index"
  resources :original_photos
  resources :personal_photos

  get "up" => "rails/health#show", as: :rails_health_check
end
