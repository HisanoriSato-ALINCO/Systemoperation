class AddColumnToPreparations < ActiveRecord::Migration[6.1]
  def change
    add_column :preparations, :action_id, :string
  end
end
