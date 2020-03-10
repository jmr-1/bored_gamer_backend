class CreateMeetups < ActiveRecord::Migration[6.0]
  def change
    create_table :meetups do |t|
      t.integer :user_id
      t.string :title
      t.string :date
      t.string :location
      t.boolean :other_games_allowed, null: false

      t.timestamps
    end
  end
end
