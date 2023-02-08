class Subscription < ApplicationRecord
  has_many :users_subscriptions, dependent: :destroy
  has_many :users, through: :users_subscriptions

  validates :title, :slug, presence: true
  validates :slug, uniqueness: true
end
