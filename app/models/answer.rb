class Answer < ApplicationRecord
  #include Searchable
  #include Searchable::Answers
  include Voteable
  include Commenteable

  belongs_to :question, touch: true
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :question, presence: true
  validates :body, presence: true
  validates :author, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best
		transaction do
			Answer.where(question_id: question.id).update_all(best: false)
			update(best: true)
		end

    if question.reward.present?
      question.reward.user = author
      question.save
    end
  end
end
