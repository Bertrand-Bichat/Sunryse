class AddTwoUserReferencesToNotification < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :sender, foreign_key: { to_table: :users }
    add_reference :notifications, :receiver, foreign_key: { to_table: :users }
  end
end
