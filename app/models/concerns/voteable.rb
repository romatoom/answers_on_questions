module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def votes_sum
    Vote.with_voteable(self).reduce(0) { |sum, vote| vote.value.present? ? sum + vote.value : sum }
  end
end
