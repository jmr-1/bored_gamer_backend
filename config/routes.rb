Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do

      resources :users, only: [:create, :index]
      resources :games, only: [:index, :show]
      post '/login', to: 'auth#create'
      get '/profile', to: 'users#profile'
      get '/collections', to: 'collections#index'
      get '/collections/show', to: 'collections#show'
      post '/collections/create', to: 'collections#create'
    end
  end 
end
