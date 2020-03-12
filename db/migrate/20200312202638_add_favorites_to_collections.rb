class AddFavoritesToCollections < ActiveRecord::Migration[6.0]
  def change
    add_column :collections, :favorite, :boolean, null: false
    add_column :collections, :owned, :boolean, null: false
  end
end
