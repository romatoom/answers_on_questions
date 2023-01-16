module Commenteable
  extend ActiveSupport::Concern

  included do
    has_many :comments, dependent: :destroy, as: :commenteable
  end
end
