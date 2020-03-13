class Api::V1::AuthController < ApplicationController
    
    skip_before_action :authorized, only: [:create]
 
  def create
    
    
    @user = User.find_by(username: user_login_params[:username])
    #User#authenticate comes from BCrypt
    if @user && @user.authenticate(user_login_params[:password])
      # encode token comes from ApplicationController
      token = encode_token({ user_id: @user.id })

      #gets the collection in addition to the user profile 
      user_collection = Collection.all.select{|collection| collection.user == @user}
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

      render json: { user: UserSerializer.new(@user), jwt: token, user_collection: new_collection }, status: :accepted
    else
      render json: { message: 'Invalid username or password' }, status: :unauthorized
    end
  end
 
  private
 
  def user_login_params
    # params { user: {username: 'Chandler Bing', password: 'hi' } }
    params.require(:user).permit(:username, :password)
  end
end
