Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get 'collection/index'
      get 'collection/show'
      get 'collection/create'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do

      resources :users, only: [:create, :index]
      resources :games, only: [:index, :show]
      post '/login', to: 'auth#create'
      get '/profile', to: 'users#profile'
    end
  end 
end
