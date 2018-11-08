class User < ApplicationRecord
  has_many :histories
  validates :slack_id, presence: true
end
