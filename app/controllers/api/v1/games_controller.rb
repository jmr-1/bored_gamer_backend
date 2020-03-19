require 'rest-client'
require 'json'
require 'pry'

class Api::V1::GamesController < ApplicationController

    skip_before_action :authorized, only: [:index, :show, :db_show, :searched_games]


    #testing dynamic array: searchParams=["&name=cata", "&fuzzy_match=true"]
    #by default, will only grab the basic 100

    def getResponse(search_params=[])
        api_key = Rails.application.credentials.project[:api_key]
        client_id = "client_id=#{api_key}"
        base_url = "https://www.boardgameatlas.com/api/search?"+client_id

        for i in search_params do 
            base_url += i
        end 

        games =  RestClient.get("#{base_url}")
        games_hash = JSON.parse(games)
        return games_hash 
    end 

    def searched_games
        #search paramaters should be an array of search strings
        search_params = []

        # games = self.getResponse(search_params)
        # render json: games["games"]
        render json: {status: "connected to BE"}
    end 

    def index 
        games = self.getResponse
        render json: games["games"] 
    end 

    def db_show
        
        #this will only show games that are actually persisting in the database
        db_games = Game.all
        render json: db_games        
    end 
    
    def show
        game = Game.all.find_by(id: params[:id])
        render json: game
    end 
    
    

     
end 