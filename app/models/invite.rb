class Invite < ApplicationRecord

    #invite status codes: 
    # 1: newly sent, no reply
    # 0: replied either affirm/deny
    # -1: archived, no longer shown in the mail 

    belongs_to :meetup
    belongs_to :receiver, class_name: 'User'
    belongs_to :inviter, class_name: 'User'
end
