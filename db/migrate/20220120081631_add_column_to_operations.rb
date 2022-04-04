class AddColumnToOperations < ActiveRecord::Migration[6.1]
  def change
    add_column :operations, :tmp_div, :string
  end
end
