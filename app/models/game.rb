class Game < ApplicationRecord

    has_many :collections
    has_many :users, through: :collections
    # has_many :meetup_collections, through: :collections #don't need, meetups only care about collective games
end
