require 'date'

class Question < ApplicationRecord
  include Searchable
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

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :title, type: :text
      indexes :body, type: :text
      indexes :author do
        indexes :id, type: :integer
        indexes :email, type: :text
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      only: [:id, :title, :body],
      include: {
        author: {
          only: [:email]
        }
      }
    )
  end

  def self.search(query)
    params = {
      query: {
        multi_match: {
          query: query,
          fields: ['title', 'body', 'author.email'],
          operator: 'and'
        }
      },
      highlight: {
        fields: {
          title: {},
          body: {},
          'author.email': {}
        }
      }
    }

    self.__elasticsearch__.search(params)
  end
end
