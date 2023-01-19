class RemoveUserToNotification < ActiveRecord::Migration[5.2]
  def change
    remove_reference :notifications, :user, index: true, foreign_key: true
  end
end
