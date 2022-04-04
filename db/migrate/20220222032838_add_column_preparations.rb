class AddColumnPreparations < ActiveRecord::Migration[6.1]
  def change
    add_column :preparations, :must_flg, :string
    remove_column :preparations, :mst_flg, :string
  end
end
