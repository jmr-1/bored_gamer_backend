class Meetup < ApplicationRecord

    belongs_to :user 
    has_many :user_meetups
    has_many :users, through: :user_meetups
    has_many :meetup_collections
    has_many :collections, through: :meetup_collections
end
