class Blockage < ApplicationRecord
  belongs_to :initiator, class_name: 'User', foreign_key: "initiator_id"
  belongs_to :target, class_name: 'User', foreign_key: "target_id"
end
