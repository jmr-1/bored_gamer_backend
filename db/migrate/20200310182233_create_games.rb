class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :game_id
      t.string :name
      t.integer :year_published
      t.integer :min_players
      t.integer :max_players
      t.string :description
      t.string :image_url
      t.integer :min_playtime
      t.integer :max_playtime

      t.timestamps
    end
  end
end
