class CreateOperations < ActiveRecord::Migration[6.1]
  def change
    create_table :operations do |t|

      t.timestamps
    end
  end
end
