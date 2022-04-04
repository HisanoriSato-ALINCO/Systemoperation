class AddcolumnToExpeople < ActiveRecord::Migration[6.1]
  def change
    add_column :expeople, :done_time, :datetime
    add_column :expeople, :set_time, :datetime
  end
end
