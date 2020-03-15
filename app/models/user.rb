class User < ApplicationRecord

    has_secure_password
    validates :username, uniqueness: {case_sensitive: false}

    has_many :collections
    has_many :games, through: :collections
    has_many :user_meetups
    has_many :meetups #needed? meetups belong to one user as well as have many users through user_meetups
    has_many :meetups, through: :user_meetups
end
