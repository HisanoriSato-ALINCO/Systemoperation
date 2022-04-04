class AddColumnToSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :default_value, :text
  end
end
