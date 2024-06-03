Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "/listings/filter" => "listings#filter"
  get '/listings/my-listings', to: 'listings#mylistings'
  get "/listings/availability" => "listings#availability"
  get '/requests/myqueue', to: 'requests#myqueue'

  resources :listings do
    resources :requests, only: [ :new, :create ]
    resources :availabilities, only: [ :index ]
  end

  resources :requests, only: [ :index ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
