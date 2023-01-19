class Order < ApplicationRecord
  belongs_to :user
  has_many :payment_intents, dependent: :destroy

  monetize :amount_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :user, presence: true
  validates :state, presence: true
  validates :order_type, presence: true
  validates :camera_credits, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :invoices_number, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # def set_cancel_date
  #   self.update(cancel_date: Date.today, active: false)
  # end
end
