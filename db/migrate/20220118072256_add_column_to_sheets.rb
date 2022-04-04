class AddColumnToSheets < ActiveRecord::Migration[6.1]
  def change
    add_column :sheets, :duty_date, :date
    add_column :sheets, :divdone, :datetime
    add_column :sheets, :predone, :datetime
    add_column :sheets, :opdone, :datetime
    add_column :sheets, :remarks, :text
    add_column :sheets, :remarks_done, :datetime
    add_column :sheets, :tmp_flg, :string
    add_column :sheets, :gex_flg, :string
  end
end
