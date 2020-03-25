class Api::V1::InvitesController < ApplicationController

    skip_before_action :authorized, only: [:create]

    def index 

    end 

    def create 
        sender = User.find_by(id: params[:profile][:id])
        meetup = Meetup.find_by(id: params[:meetup][:meetup_details][:id])
        description = params[:description]
        inviteList = params[:inviteList]

        render json: {status: "Connected to BE", sender: sender, meetup: meetup, description: description, 
            inviteList: inviteList
        }
    end 


end
