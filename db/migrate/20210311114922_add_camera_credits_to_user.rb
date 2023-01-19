class AddCameraCreditsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :camera_credits_balance, :integer, default: 0, null: false
  end
end
