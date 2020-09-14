Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do

      resources :users, only: [:create, :index]
      resources :games, only: [:index, :show]
      resources :meetups, only: [:index, :create]
      get '/db_games', to: 'games#db_show' #need to make different, otherwise games/:id will try to search for games/db_games
      post '/login', to: 'auth#create'
      get '/profile', to: 'users#profile'
      get '/collections', to: 'collections#index'
      get '/collections/show', to: 'collections#show'
      post '/collections/create', to: 'collections#create'
      get '/users/collection/:id', to: 'users#user_collection' #using id, find the collection status of a user 
      get '/meetups/detailed', to: 'meetups#detailed_meetups'
      post '/meetups/join', to: 'meetups#add_or_remove_user_to_meetup'
      post '/games/search', to: 'games#searched_games' #can take in any number of search parameters
      post '/meetups/addgame', to: 'meetups#modify_games_in_meetup'
      post '/invites/create', to: 'invites#create'
      get '/invites/user/:id', to: 'invites#user_invites'
      get '/invites', to: 'invites#index'
      post '/invites/reply', to: 'invites#reply'

      get '*path', to: "application#fallback_index_html", constraints: ->(request) do
        !request.xhr? && request.format.html?
      end
    end
  end 
end
