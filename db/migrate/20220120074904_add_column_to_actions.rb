class AddColumnToActions < ActiveRecord::Migration[6.1]
  def change
    add_column :actions, :command, :string
    add_column :actions, :caution, :string
  end
end
