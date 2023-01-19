class AddPaidDateToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :paid_date, :date
  end
end
