class AddCancelDateToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :cancel_date, :date
  end
end
