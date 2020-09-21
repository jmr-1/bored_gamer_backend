class Api::V1::MeetupsController < ApplicationController

    #remove create before deployment 
    skip_before_action :authorized, only: [:index, :create, :detailed_meetups, :add_or_remove_user_to_meetup, :modify_games_in_meetup]

    def index 

        meetups = Meetup.all
        render json: meetups
    end 

    def create

        meetup = Meetup.create(
            title: params[:form][:event],
            description: params[:form][:description],
            date: params[:date],
            location: params[:form][:location],
            other_games_allowed: params[:form][:allowed]
        )
        user = User.find_by(id: params[:profile][:id])
        meetup.user = user 
        meetup.users << user

        chosen_games = params[:form][:chosenGames]
        if chosen_games.length >= 1 
            chosen_games.each do |game_id|
                game = Collection.find_by(game_id: game_id, user_id: user.id)
                meetup.collections << game 
            end 
        end 
        meetup.save

        #formatted the meetup post request to render the same info as detailed_meetups. Both will render components in a standard way.
        meetup_collection = []
        meetup.collections.each do |collection|
            collObj = {}
            collObj["owner"] = collection.user
            collObj["game"] = collection.game
            meetup_collection << collObj
        end 
        
        newObj = {}
        newObj["collection"] = meetup_collection
         
        render json: {status: "received", meetup_details: meetup, host: meetup.user, participants: meetup.users, collection: newObj["collection"]}
    end 

    def detailed_meetups

        meetups = Meetup.all 

        detailed_array = []

        meetups.each do |meetup|

            newObj = {}
            newObj["meetup_details"] = meetup
            newObj["host"] = meetup.user
            newObj["participants"] = meetup.users
            
            meetup_collection = []
            meetup.collections.each do |collection|
                collObj = {}
                collObj["owner"] = collection.user
                collObj["game"] = collection.game
                meetup_collection << collObj
            end 
            newObj["collection"] = meetup_collection
            detailed_array << newObj
        end 

        render json: detailed_array
    end 

    def add_or_remove_user_to_meetup
        user = User.find_by(id: params[:user])
        meetup = Meetup.find_by(id: params[:meetup])
        result = meetup.users.find{|member| member == user }

        result ? meetup.users.delete(user) : meetup.users << user
        # if(!result)
        #     meetup.users << user
        # elsif(result)
        #     meetup.users.delete(user)
        # end 

        meetups = Meetup.all 
        detailed_array = []
        meetups.each do |meetup|
            newObj = {}
            newObj["meetup_details"] = meetup
            newObj["host"] = meetup.user
            newObj["participants"] = meetup.users
            
            meetup_collection = []
            meetup.collections.each do |collection|
                collObj = {}
                collObj["owner"] = collection.user
                collObj["game"] = collection.game
                meetup_collection << collObj
            end 
            newObj["collection"] = meetup_collection
            detailed_array << newObj
        end 

        # why return the entire array? Just return the modified object like below
        render json: detailed_array
    end 


    def modify_games_in_meetup

        user = User.find_by(id: params[:userID])
        meetup = Meetup.find_by(id: params[:meetupID])

        chosen_games = params[:chosenGames]
        if chosen_games.length >= 1 
            chosen_games.each do |game_id|
                game = Collection.find_by(game_id: game_id, user_id: user.id)
                
                if !meetup.collections.include?(game)
                    meetup.collections << game 
                elsif meetup.collections.find{|collection_game| collection_game == game }
                    meetup.collections.delete(game)
                end 
            end 
        end 
        meetup_collection = []
        meetup.collections.each do |collection|
            collObj = {}
            collObj["owner"] = collection.user
            collObj["game"] = collection.game
            meetup_collection << collObj
        end 

        render json: {meetup_details: meetup, host: meetup.user, participants: meetup.users, collection: meetup_collection}
    end 
end
