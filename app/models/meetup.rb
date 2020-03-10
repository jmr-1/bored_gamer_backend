class Meetup < ApplicationRecord

    belongs_to :user 
    has_many :meetup_users 
    has_many :users, through: :meetup_users
    has_many :meetup_user_games
    has_many :user_games, through: :meetup_user_games
end
