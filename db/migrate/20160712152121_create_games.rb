class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :score
      t.integer :shots
      t.text :game_board

      t.timestamps null: false
    end
  end
end
