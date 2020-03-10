class CreateMeetupUserGames < ActiveRecord::Migration[6.0]
  def change
    create_table :meetup_user_games do |t|
      t.integer :meetup_id
      t.integer :user_game_id
      t.timestamps
    end
  end
end
