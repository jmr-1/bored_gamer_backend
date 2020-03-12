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

    collection = Collection.new
    collection.user = user
    collection.game = game 
    updated_key = params[:collection][:updated]
    collection[updated_key] = true 
    collection.save 

    render json: {status: "new collection successful", gameTest: game, user: user, collection: collection }
  end


  private

  def collections_params

    params.require(:collection).permit(:user_id, :game_id, :name, :year_published, :min_players, :max_players, :description, :image_url, :min_playtime, :max_playtime, :updated)
  end 
end
