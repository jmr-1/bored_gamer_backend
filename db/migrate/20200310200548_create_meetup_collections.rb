class CreateMeetupCollections < ActiveRecord::Migration[6.0]
  def change
    create_table :meetup_collections do |t|
      t.integer :collection_id
      t.integer :meetup_id

      t.timestamps
    end
  end
end
