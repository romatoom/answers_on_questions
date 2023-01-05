class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :voteable, :user, presence: true

  scope :with_voteable, -> (voteable) { where(voteable: voteable) }
end
