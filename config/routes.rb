Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users,
                 skip: %i[passwords confirmations],
                 path: "",
                 path_names: {
                   sign_in: "login",
                   sign_out: "logout",
                   registration: "signup",
                 },
                 controllers: {
                   sessions: "api/v1/sessions",
                   registrations: "api/v1/registrations",
                 }

      resources :households
      resource :profile, only: %i[show update]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
