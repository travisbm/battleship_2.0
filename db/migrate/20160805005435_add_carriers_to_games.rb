class AddCarriersToGames < ActiveRecord::Migration
  def change
    add_column :games, :carriers, :integer
  end
end
