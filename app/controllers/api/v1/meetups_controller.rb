class Api::V1::MeetupsController < ApplicationController

    #remove create before deployment 
    skip_before_action :authorized, only: [:index, :create]

    def index 

        meetups = Meetup.all
        render json: {status: "meetups go here", meetups: meetups}
    end 

    def create

        meetup = Meetup.new(
            title: params[:form][:event],
            date: params[:form][:date],
            location: params[:form][:location],
            other_games_allowed: params[:form][:allowed]
        )
        user = User.find_by(id: params[:profile][:id])
        meetup.user = user 
         
        render json: {status: "received", meetup: meetup, participants: meetup.users}
    end 
end
