class Comment < ApplicationRecord
  belongs_to :commenteable, polymorphic: true
  belongs_to :user

  validates :commenteable, :user, presence: true
end
