class Api::V1::MeetupsController < ApplicationController

    #remove create before deployment 
    skip_before_action :authorized, only: [:index, :create]

    def index 

        meetups = Meetup.all
        render json: {status: "meetups go here", meetups: meetups}
    end 

    def create

        byebug 
        render json: {status: "received"}
    end 


    private 
    
    def meetups_params

    end 
end
