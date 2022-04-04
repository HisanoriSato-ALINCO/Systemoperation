class AddColumnTochoices < ActiveRecord::Migration[6.1]
  def change
    add_column :choices, :choice_code, :string
    add_column :choices, :choice_name, :string
    add_column :choices, :set_code, :string
    add_column :choices, :op_code, :string
  end
end
