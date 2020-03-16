class Collection < ApplicationRecord

    belongs_to :game
    belongs_to :user
    has_many :meetup_collections
    has_many :meetups, through: :meetup_collections
end
