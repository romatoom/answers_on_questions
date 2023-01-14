class Question < ApplicationRecord
  include Voteable
  include Commenteable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  has_one :reward, dependent: :destroy
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :title, uniqueness: true
end
