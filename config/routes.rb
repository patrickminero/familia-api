Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api do
    namespace :v1 do
      post "signup", to: "registrations#create"
      post "login", to: "sessions#create"
      delete "logout", to: "sessions#destroy"

      resource :profile, only: %i[show update]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
