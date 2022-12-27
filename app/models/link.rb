class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  REGEXP_GIST = /^https:\/\/gist\.github\.com\/(?<nickname>.+)\/(?<gist_id>[a-f\d]+)$/

  def match_gist
    url.match(REGEXP_GIST)
  end
end
