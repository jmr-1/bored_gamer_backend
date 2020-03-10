class Game < ApplicationRecord

    has_many :collections
    has_many :users, through: :collections
    has_many :meetup_collections, through: :collections
end
