class Api::V1::UsersController < ApplicationController

    skip_before_action :authorized, only: [:create, :index, :user_collection] #remove index and user_collection for production

    def profile
        render json: {user: UserSerializer.new(current_user)}, status: :accepted
    end 

    def create

        @user = User.create(user_params)
        if @user.valid?
            @token = encode_token(user_id: @user.id)
            render json: {user: UserSerializer.new(@user), jwt: @token}, status: :created
        else
            render json: {error: 'failed to create user'}, status: :not_acceptable
        end 
    end 

    #used for db searching only, remove from routes when needed
    def index

        users = User.all 
        render json: users 
    end 

    #used for db searching, remove from routes when needed
    def user_collection

        user = User.find_by(id: params[:id])
        user_collection = Collection.all.select{|collection| collection.user == user}
        # user_collection = user_collection.map{|collection| collection.game}

        new_collection = []

        user_collection.each do |collection|

            new_obj = {}
            game = collection.game 

            new_obj["game_id"] = game.game_id 
            new_obj["name"] = game.name 
            new_obj["year_published"] = game.year_published
            new_obj["min_players"] = game.min_players
            new_obj["max_players"] = game.max_players 
            new_obj["description"] = game.description 
            new_obj["image_url"] = game.image_url 
            new_obj["max_playtime"] = game.max_playtime
            new_obj["min_playtime"] = game.min_playtime  
            new_obj["favorite"] = collection.favorite
            new_obj["owned"] = collection.owned

            new_collection << new_obj
        end 

        #renders a user id's collection and includes favorite/owned status 
        render json: new_collection
    end 

    private 

    def user_params
        params.require(:user).permit(:username, :password, :bio, :avatar, :name)
    end
end
