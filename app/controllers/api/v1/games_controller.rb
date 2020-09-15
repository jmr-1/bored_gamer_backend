require 'rest-client'
require 'json'
require 'pry'

class Api::V1::GamesController < ApplicationController

    #check to make sure this doesn't require token 
    skip_before_action :authorized, only: [:index, :show, :db_show, :searched_games, :getResponse, :get_searched_games]


    #testing dynamic array: searchParams=["&name=cata", "&fuzzy_match=true"]
    #by default, will only grab the basic 100

    def getResponse(search_params=[])

        api_key = Rails.application.credentials.project[:api_key]
        client_id = "client_id=#{api_key}"

        #Changed url for api on 2020.8.1
        new_base_url = "https://api.boardgameatlas.com/api/search?"+client_id
        
        for search in search_params do 
            new_base_url += search
        end 
        
        new_games = RestClient.get("#{new_base_url}")
        return new_games_hash = JSON.parse(new_games)
    end 


    def searched_games
        #search paramaters should be an array of search strings
        search_params = []
        
        #instead of an endless list of if-then statements, perhaps create a dictionary?
        #or map each key to a url string?
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