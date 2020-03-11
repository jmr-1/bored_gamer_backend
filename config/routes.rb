Rails.application.routes.draw do

  #these routes are not used, api/v1 is where all controllers are located 
  # get 'users/index'
  # get 'users/show'
  # get 'users/create'
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
