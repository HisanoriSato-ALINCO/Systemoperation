class CreateExpeople < ActiveRecord::Migration[6.1]
  def change
    create_table :expeople do |t|

      t.timestamps
    end
  end
end
