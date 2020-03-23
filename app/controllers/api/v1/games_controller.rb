require 'rest-client'
require 'json'
require 'pry'

class Api::V1::GamesController < ApplicationController

    skip_before_action :authorized, only: [:index, :show, :db_show, :searched_games, :getResponse]


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
        

        if(params[:gameID])
            search_params << "&ids=#{params[:gameID]}"
        end 
        if(params[:kickstarter])
            search_params << "&kickstarter=true"
        end 
        if(params[:designer])
            search_params << "&designer=#{params[:designer]}"
        end 
        if(params[:title])
            search_params << "&name=#{params[:title]}"
        end 
        if(params[:min_players])
            search_params << "&min_players=#{params[:min_players]}"
        end 
        if(params[:max_players])
            search_params << "&min_players=#{params[:max_players]}"
        end 
        if(params[:year_published])
            search_params << "&year_published=#{params[:year_published]}"
        end 
        if(params[:random])
            search_params << "&random=true"
        end 
        if(params[:fuzzy_match])
            search_params << "&fuzzy_match=true"
        end 

        result = self.getResponse(search_params)
        render json: {parameters: params, result: result["games"], random: result["game"]}
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