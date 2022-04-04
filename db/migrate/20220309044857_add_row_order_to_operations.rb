class AddRowOrderToOperations < ActiveRecord::Migration[6.1]
  def change
    add_column :operations, :row_order, :integer
  end
end
