class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: "author_id"

  validates :question, presence: true
  validates :body, presence: true
  validates :author, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best
		transaction do
			Answer.where(question_id: self.question_id).update_all(best: false)
			update(best: true)
		end
  end
end
