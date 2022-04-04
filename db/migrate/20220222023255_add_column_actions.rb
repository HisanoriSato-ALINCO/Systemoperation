class AddColumnActions < ActiveRecord::Migration[6.1]
  def change
    add_column :actions, :a_c_div, :string
  end
end
