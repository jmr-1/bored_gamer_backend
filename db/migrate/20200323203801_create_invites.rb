class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.integer :inviter_id
      t.integer :receiver_id
      t.integer :meetup_id
      t.string :description
      t.integer :status, default: 1 
      t.timestamps
    end
  end
end
