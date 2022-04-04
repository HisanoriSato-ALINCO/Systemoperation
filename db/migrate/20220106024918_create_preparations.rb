class CreatePreparations < ActiveRecord::Migration[6.1]
  def change
    create_table :preparations do |t|

      t.timestamps
    end
  end
end
