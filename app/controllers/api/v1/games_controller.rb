require 'rest-client'
require 'json'
require 'pry'

class Api::V1::GamesController < ApplicationController

    skip_before_action :authorized, only: [:index, :show, :db_show, :searched_games, :getResponse, :get_searched_games]

    def getResponse(search_params=[])

        api_key = Rails.application.credentials.project[:api_key]
        # move api key to environment for production
        # api_key = ENV["MY_API_KEY"]
        client_id = "client_id=#{api_key}"
        new_base_url = "https://api.boardgameatlas.com/api/search?"+client_id
        
        for search in search_params do 
            new_base_url += search
        end 
        
        new_games = RestClient.get("#{new_base_url}")
        return new_games_hash = JSON.parse(new_games)
    end 

    def insert_search_string(search_string="", value="")
        return "#{search_string}#{value}"
    end

    def searched_games

        search_params = []

        params_dictionary = {
            gameID: "&ids=",
            kickstarter: "&kickstarter=",
            designer: "&designer=",
            title: "&name=",
            min_players: "&min_players=",
            max_players: "&max_players=",
            year_published: "&year_published=",
            random: "&random=",
            fuzzy_match: "&fuzzy_match=",
            publisher: "&publisher="
        }.with_indifferent_access

        search_obj.each do |search, value|
            if value != false
                search_params << self.insert_search_string(params_dictionary[search], value)
            end 
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

    private 
    
    def search_obj
        params.require(:searchParams).permit(:gameID, :kickstarter, :designer, :title, :min_players, :max_players, :year_published, 
        :random, :fuzzy_match, :publisher)
    end 
end 