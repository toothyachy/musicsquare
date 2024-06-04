Rails.application.routes.draw do
  devise_for :users
  root to: "listings#index"

  get "/listings/filter" => "listings#filter"
  get '/listings/my-listings' => 'listings#mylistings'
  get "/listings/availability" => "listings#availability"
  get '/requests/myqueue' => 'requests#myqueue'

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

  get "up" => "rails/health#show", as: :rails_health_check
end
