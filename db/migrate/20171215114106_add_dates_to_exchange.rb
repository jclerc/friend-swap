class AddDatesToExchange < ActiveRecord::Migration[5.1]
  def change
    add_column :exchanges, :start_date, :datetime
    add_column :exchanges, :end_date, :datetime
  end
end
