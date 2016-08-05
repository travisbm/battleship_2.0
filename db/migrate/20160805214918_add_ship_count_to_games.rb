class AddShipCountToGames < ActiveRecord::Migration
  def change
    add_column :games, :ship_count, :text
  end
end
