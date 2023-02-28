require 'date'

class Question < ApplicationRecord
  #include Searchable
  #include Searchable::Questions
  include Voteable
  include Commenteable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :author, class_name: "User", foreign_key: "author_id", touch: true
  has_one :reward, dependent: :destroy
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :title, uniqueness: true

  scope :created_in_the_last_day, -> { where(created_at: 1.day.ago..Time.current) }
end
