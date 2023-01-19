class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :state
      t.integer :amount_cents, default: 0, null: false
      t.string :checkout_session_id
      t.references :user, foreign_key: true
      t.string :subscription_id
      t.string :order_type
      t.boolean :active, default: false, null: false
      t.string :duration
      t.integer :camera_credits, default: 0, null: false

      t.timestamps
    end
  end
end
