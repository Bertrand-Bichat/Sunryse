class Chatroom < ApplicationRecord
  belongs_to :speaker1, class_name: 'User', foreign_key: "speaker1_id"
  belongs_to :speaker2, class_name: 'User', foreign_key: "speaker2_id"

  has_many :posts, dependent: :destroy
end
