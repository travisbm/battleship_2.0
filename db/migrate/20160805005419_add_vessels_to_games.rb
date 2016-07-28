class AddVesselsToGames < ActiveRecord::Migration
  def change
    add_column :games, :vessels, :integer
  end
end
