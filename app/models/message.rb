class Message < ApplicationRecord
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: 'Doit être une adresse email valide' }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :content, presence: true
  validates :phone_number, presence: true
end
