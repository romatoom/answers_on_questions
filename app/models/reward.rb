class Reward < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question
  has_one_attached :image

  validates :question, :title, :image, presence: true
  validates :question, uniqueness: true
end
