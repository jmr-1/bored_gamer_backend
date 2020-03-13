Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do

      resources :users, only: [:create, :index]
      resources :games, only: [:index, :show]
      resources :meetups, only: [:index]
      get '/db_games', to: 'games#db_show' #need to make different, otherwise games/:id will try to search for games/db_games
      post '/login', to: 'auth#create'
      get '/profile', to: 'users#profile'
      get '/collections', to: 'collections#index'
      get '/collections/show', to: 'collections#show'
      post '/collections/create', to: 'collections#create'
      get '/users/collection/:id', to: 'users#user_collection' #using id, find the collection status of a user 
      
    end
  end 
end
