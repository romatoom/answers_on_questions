class Comment < ApplicationRecord
  #include Searchable
  #include Searchable::Comments

  belongs_to :commenteable, polymorphic: true, touch: true
  belongs_to :author, class_name: "User", foreign_key: "author_id"

  validates :commenteable, :author, :body, presence: true

  def formatted_creation_date
    created_at.strftime('%H:%M:%S %d.%m.%Y')
  end
end
