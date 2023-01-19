class CreatePaymentIntents < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_intents do |t|
      t.string :payment_intent_id
      t.integer :amount_cents, default: 0, null: false
      t.references :order, foreign_key: true
      t.string :refund_id
      t.string :refund_status

      t.timestamps
    end
  end
end
