class ChangeColumnOperations < ActiveRecord::Migration[6.1]
  def change
    add_index :operations, :op_code, unique: true

  end
end
