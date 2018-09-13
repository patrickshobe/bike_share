Rails.application.routes.draw do

  root 'welcome#index'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  get '/dashboard' => 'users#dashboard'
  get '/trips-dashboard' => 'trips#dashboard'

  resources :users, only: [:new, :create] do
    resources :orders, only: [:create]
  end
  resources :carts, only: [:create, :index]
  resources :stations, only: [:show, :index]
  resources :trips, only: [:index, :show]
  resources :conditions, only: [:index, :show]
	resources :accessories, only: :show
  resources :orders, only: [:show, :create]

  delete '/carts', to: 'carts#destroy'
  post '/carts', to: 'carts#create'
  put '/carts', to: 'carts#update'

  get '/bike-shop', to: 'accessories#index'
  get '/dashboard', to: 'users#dashboard'
  get '/stations-dashboard', to: 'stations#dashboard'
  get '/conditions-dashboard', to: 'conditions#dashboard'
end
