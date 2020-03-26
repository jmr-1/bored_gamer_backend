class Api::V1::InvitesController < ApplicationController

    skip_before_action :authorized, only: [:create, :index, :user_invites]

    def index 
        invites = Invite.all 

        render json: invites 
    end 

    def create 
        sender = User.find_by(id: params[:profile][:id])
        meetup = Meetup.find_by(id: params[:meetup][:meetup_details][:id])
        description = params[:description]
        inviteList = params[:inviteList]

        #create a new invite for each invited guest

        invites_sent = []

        inviteList.each do |receiver_id_only|
            receiver = User.find_by(id: receiver_id_only )
            invite = Invite.new 
            invite.meetup = meetup
            invite.inviter = sender
            invite.receiver = receiver 
            invite.description = description 
            invite.save 
            new_invite_obj = {}
            new_invite_obj["invite_details"] = invite 
            new_invite_obj["receiver"] = invite.receiver
            new_invite_obj["inviter"] = invite.inviter
            new_invite_obj["meetup"] = invite.meetup 
            invites_sent << new_invite_obj 
        end 

        # senders_invites = Invite.all.find_by(sender: sender)

        render json: {invites_sent: invites_sent }
    end 

    def user_invites 

        user = User.find_by(id: params[:id])

        users_invites = Invite.all.select{|invite| invite.receiver == user || invite.inviter == user}

        invites = []

        users_invites.each do |invite|
            new_invite_obj = {}
            new_invite_obj["invite_details"] = invite
            new_invite_obj["receiver"] = invite.receiver
            new_invite_obj["inviter"] = invite.inviter
            new_invite_obj["meetup"] = invite.meetup 
            invites << new_invite_obj
        end 

        render json: {user: user, users_invites: invites}
    end 
end
