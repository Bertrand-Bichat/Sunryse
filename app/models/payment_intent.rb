class PaymentIntent < ApplicationRecord
  belongs_to :order

  monetize :amount_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :payment_intent_id, presence: true, uniqueness: true
end
