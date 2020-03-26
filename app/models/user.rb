class User < ApplicationRecord

    has_secure_password
    validates :username, uniqueness: {case_sensitive: false}
    validates :name, :bio, presence: true

    has_many :collections
    has_many :games, through: :collections
    has_many :user_meetups
    has_many :meetups #needed? meetups belong to one user as well as have many users through user_meetups
    has_many :meetups, through: :user_meetups

    has_many :received_users, foreign_key: :receiver_id, class_name: 'Invite'
    has_many :inviters, through: :received_users  
    has_many :invited_users, foreign_key: :inviter_id, class_name: 'Invite'
    has_many :receivers, through: :invited_users 
end
