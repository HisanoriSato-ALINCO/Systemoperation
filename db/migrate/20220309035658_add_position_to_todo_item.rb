class AddPositionToTodoItem < ActiveRecord::Migration[6.1]
  def change
    add_column :operations, :position, :integer
  end
end
