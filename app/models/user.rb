class User < ApplicationRecord

    has_secure_password
    validates :username, uniqueness: {case_sensitive: false}

    has_many :user_games 
    has_many :user_meetups
    has_many :meetups, through: :user_meetups
    has_many :meetup_user_games, through: user_games
end
