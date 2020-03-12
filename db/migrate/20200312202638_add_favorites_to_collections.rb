class AddFavoritesToCollections < ActiveRecord::Migration[6.0]
  def change
    add_column :collections, :favorite, :boolean, default: false
    add_column :collections, :owned, :boolean, default: false
  end
end
