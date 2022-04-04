class AddColumnToSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :operation_id, :string
  end
end
