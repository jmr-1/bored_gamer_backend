class Api::V1::InvitesController < ApplicationController

    skip_before_action :authorized, only: [:create, :index, :user_invites, :reply]

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

    def reply
        meetup_update = Meetup.all.find_by(id: params[:meetupID])
        user = User.all.find_by(id: params[:profileID])
        response = params[:response]
        invitation = Invite.all.find_by(id: params[:inviteID]) 

        #check to make sure user isn't already in the meetup even if it's handled in front-end
        result = meetup_update.users.find{|member| member == user }
        if(!result && response == "accept")

            meetup_update.users << user 
            invitation.status = 0
            invitation.save
        end 

        if(response == "deny")

            invitation.status = 0
            invitation.save
        end 

        #db changes above. Below is just reply to FE to update state.
        #needs to be array to be in the same format
        invite_to_be_updated = []
            new_invite_obj = {}
            new_invite_obj["invite_details"] = invitation
            new_invite_obj["receiver"] = invitation.receiver
            new_invite_obj["inviter"] = invitation.inviter
            new_invite_obj["meetup"] = invitation.meetup 
            invite_to_be_updated << new_invite_obj

        meetup_to_be_updated = []
            newObj = {}
            newObj["meetup_details"] = meetup_update
            newObj["host"] = meetup_update.user
            newObj["participants"] = meetup_update.users
            
            meetup_collection = []
            meetup_update.collections.each do |collection|
                collObj = {}
                collObj["owner"] = collection.user
                collObj["game"] = collection.game
                meetup_collection << collObj
            end 
            newObj["collection"] = meetup_collection
            meetup_to_be_updated << newObj


        render json: {invite: invite_to_be_updated, meetup: meetup_to_be_updated}
    end 
end
