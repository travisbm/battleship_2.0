class AddBoatsToGames < ActiveRecord::Migration
  def change
    add_column :games, :boats, :integer
  end
end
