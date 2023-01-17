class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :rewards
  has_many :votes

  def author_of?(record)
    record.respond_to?(:author) && record.author == self
  end

  def can_vote?(voteable)
    !author_of?(voteable) && votes.where(voteable: voteable).empty?
  end

  def can_revote?(voteable)
    !author_of?(voteable) && votes.where(voteable: voteable).present?
  end

  def like?(voteable)
    vote = votes.find_by(voteable: voteable)
    return if vote.nil?

    vote.value > 0
  end

  def dislike?(voteable)
    like = like?(voteable)
    return if like.nil?

    !like
  end
end
