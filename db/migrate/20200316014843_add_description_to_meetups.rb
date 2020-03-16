class AddDescriptionToMeetups < ActiveRecord::Migration[6.0]
  def change
    add_column :meetups, :description, :string
  end
end
