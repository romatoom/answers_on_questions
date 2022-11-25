class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: "User", foreign_key: "author_id"

  validates :title, :body, presence: true
  validates :title, uniqueness: true
end
