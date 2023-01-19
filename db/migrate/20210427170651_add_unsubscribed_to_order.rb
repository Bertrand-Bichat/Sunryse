class AddUnsubscribedToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :unsubscribed, :boolean, default: false, null: false
  end
end
