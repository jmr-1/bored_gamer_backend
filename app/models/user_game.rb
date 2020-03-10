class UserGame < ApplicationRecord

    belongs_to :game
    belongs_to :user
    has_many :meetup_user_games
    has_many :meetups, through: :meetup_user_games
end
