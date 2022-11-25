class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: "author_id"

  validates :question, presence: true
  validates :body, presence: true
  validates :author, presence: true
end
