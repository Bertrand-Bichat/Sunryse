class Event < ApplicationRecord
  validates :stripe_id, presence: true, uniqueness: true
end
