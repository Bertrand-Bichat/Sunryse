class AddInvoicesNumberToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :invoices_number, :integer, default: 0, null: false
  end
end
