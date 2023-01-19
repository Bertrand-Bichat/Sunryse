class Favorite < ApplicationRecord
  belongs_to :user

  validates :profile_id, presence: true
end
