require 'rest-client'
require 'json'
require 'pry'

class Api::V1::GamesController < ApplicationController

    skip_before_action :authorized, only: [:index, :show]

    
    def getResponse
        api_key = Rails.application.credentials.project[:api_key]
        client_id = "client_id=#{api_key}"
        base_url = "https://www.boardgameatlas.com/api/search?"

        games =  RestClient.get("#{base_url+client_id}")
        games_hash = JSON.parse(games)
        return games_hash 
    end 

    def index 
        games = self.getResponse
        render json: games["games"] 
    end 
    
    def show

        #this will only show games that are actually persisting in the database
        db_games = Game.all
        render json: db_games        
    end 
    

     
end 