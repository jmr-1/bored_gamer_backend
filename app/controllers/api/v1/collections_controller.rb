require 'pry'
require 'byebug'

class Api::V1::CollectionsController < ApplicationController

  # still needs to skip before action. Will no longer need to skip once token is utilized
  skip_before_action :authorized, only: [:index, :show, :create]
  def index
    collections = Collection.all
    render json: collections
  end

  def show
  end

  def create

    # This will also create the Game object. With a live API, games_table only needs to get populated in order to have info for the collection
    user = User.find_by(id: params[:collection][:user_id])
    game = Game.find_or_create_by(game_id: params[:collection][:game_id]) do |game|
      game.game_id = params[:collection][:game_id]
      game.name = params[:collection][:name]
      game.year_published = params[:collection][:year_published].to_i
      game.min_players = params[:collection][:min_players].to_i
      game.max_players = params[:collection][:max_players].to_i
      game.description = params[:collection][:description]
      game.image_url = params[:collection][:image_url]
      game.min_playtime = params[:collection][:min_playtime].to_i
      game.max_playtime = params[:collection][:max_playtime].to_i
    end 

    collection = Collection.find_or_create_by(user: user, game: game) do |collection|
      collection.user = user
      collection.game = game 
    end 
    updated_key = params[:collection][:updated]

    #regression test working, new feature working. Can later refactor to one line:
    # collection[updated_key] = !collection[updated_key]
    # favorite/unfavorite game, add/remove game from collection
    if !collection[updated_key]
      collection[updated_key] = true 
    elsif collection[updated_key]
      collection[updated_key] = false
    end 
    
    collection.save

    # render json: {status: "new collection successful", gameTest: game, user: user, collection: collection }
    user_collection = Collection.all.select{|collection| collection.user == user}
    # user_collection = user_collection.map{|collection| collection.game}

    #same code as users#user_collection below
    new_collection = []

        user_collection.each do |collection|

            new_obj = {}
            game = collection.game 

            new_obj["id"] = game.id
            new_obj["game_id"] = game.game_id 
            new_obj["name"] = game.name 
            new_obj["year_published"] = game.year_published
            new_obj["min_players"] = game.min_players
            new_obj["max_players"] = game.max_players 
            new_obj["description"] = game.description 
            new_obj["image_url"] = game.image_url 
            new_obj["max_playtime"] = game.max_playtime
            new_obj["min_playtime"] = game.min_playtime  
            new_obj["favorite"] = collection.favorite
            new_obj["owned"] = collection.owned

            new_collection << new_obj
        end 
      
        #same code as users#user_collection above 
        
        #could try redirecting to users_controller#user_collection instead 
        #renders a user id's collection and includes favorite/owned status 
    render json: {user: user, user_collection: new_collection}
  end


  private

  def collections_params

    params.require(:collection).permit(:user_id, :game_id, :name, :year_published, :min_players, :max_players, :description, :image_url, :min_playtime, :max_playtime, :updated)
  end 
end
