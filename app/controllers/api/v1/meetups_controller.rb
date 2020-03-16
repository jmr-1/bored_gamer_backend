class Api::V1::MeetupsController < ApplicationController

    #remove create before deployment 
    skip_before_action :authorized, only: [:index, :create]

    def index 

        meetups = Meetup.all
        render json: {status: "meetups go here", meetups: meetups}
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
         
        render json: {status: "received", meetup: meetup, participants: meetup.users, collection: meetup.collections}
    end 
end
