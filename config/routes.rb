Rails.application.routes.draw do
  devise_for :users
  root to: "listings#index"

  get "/listings/filter", to: "listings#filter"
  get '/listings/my-listings', to: 'listings#mylistings'
  get "/listings/availability", to: "listings#availability"
  get '/requests/myqueue', to: 'requests#myqueue'

  resources :listings do
    resources :requests, only: [ :new, :create ]
    resources :availabilities, only: [ :index ]
  end

  resources :requests, only: [ :index, :edit, :update ] do
    member do
      patch :accept
      patch :decline
    end
  end

  resources :users, only: [:show]

  get "up" => "rails/health#show", as: :rails_health_check
end
