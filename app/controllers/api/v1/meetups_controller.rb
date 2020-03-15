class Api::V1::MeetupsController < ApplicationController

    skip_before_action :authorized, only: [:index]

    def index 

        meetups = Meetup.all
        render json: {status: "meetups go here", meetups: meetups}
    end 

    def create

    end 
end
