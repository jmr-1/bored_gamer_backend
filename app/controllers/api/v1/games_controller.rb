require 'rest-client'
require 'json'
require 'pry'

class Api::V1::GamesController < ApplicationController

    #check to make sure this doesn't require token 
    skip_before_action :authorized, only: [:index, :show, :db_show, :searched_games, :getResponse, :get_searched_games]

    def getResponse(search_params=[])

        # api_key = Rails.application.credentials.project[:api_key]
        # move api key to environment for production
        api_key = ENV["MY_API_KEY"]
        client_id = "client_id=#{api_key}"

        # Change base_url on 2020.8.1 in order to main functionality.        
        new_base_url = "https://api.boardgameatlas.com/api/search?"+client_id
        
        for search in search_params do 
            new_base_url += search
        end 
        
        new_games = RestClient.get("#{new_base_url}")
        return new_games_hash = JSON.parse(new_games)
    end 


    def searched_games

        search_params = []
        # test_params = []

        # params_dictionary = {
        #     gameID: "&ids=#{value}",
        #     kickstarter: "&kickstarter=true",
        #     designer: "&designer=#{value}",
        #     title: "&name=#{value}",
        #     min_players: "&min_players=#{value}",
        #     max_players: "&max_players=#{value}",
        #     year_published: "&year_published=#{value}",
        #     random: "&random=true",
        #     fuzzy_match: "&fuzzy_match=true"
        # }

        # params.each do |search, value|
        #     if(params_dictionary[:search])
        #     test_params << params_dictionary[:search]
        #     end 
        # end 

        # binding.pry
        
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
            search_params << "&max_players=#{params[:max_players]}"
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