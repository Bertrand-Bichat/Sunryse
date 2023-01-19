class AddNinjaToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ninja_time, :integer, default: 30, null: false
    add_column :users, :ninja_activated, :boolean, default: false, null: false
    add_column :users, :ninja_reset, :boolean, default: false, null: false
  end
end
