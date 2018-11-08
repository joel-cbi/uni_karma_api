class User < ApplicationRecord
  has_many :histories
  validates :slack_name, presence: true
  validates :slack_id, presence: true
end
