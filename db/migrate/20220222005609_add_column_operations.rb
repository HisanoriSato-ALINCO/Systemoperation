class AddColumnOperations < ActiveRecord::Migration[6.1]
  def change
    add_column :operations, :ex_div, :string
  end
end