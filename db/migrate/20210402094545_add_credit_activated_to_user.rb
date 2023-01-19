class AddCreditActivatedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :credit_activated, :boolean, default: false, null: false
  end
end
