class DropCells < ActiveRecord::Migration
  def change
    drop_table :cells
  end
end
