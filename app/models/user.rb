class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :telegram]

  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :rewards
  has_many :votes
  has_many :authorizations, dependent: :destroy

  has_many :users_subscriptions, dependent: :destroy
  has_many :subscriptions, through: :users_subscriptions

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def self.create_with_email(email)
    password = Devise.friendly_token[0, 20]
    user = User.create!(email: email, password: password, password_confirmation: password)
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end

  def author_of?(record)
    record.respond_to?(:author) && record.author == self
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

  def subscription_by_slug(subscription_slug, question)
    subscription = Subscription.find_by(slug: subscription_slug)
    users_subscriptions.where(subscription: subscription, question: question).first
  end
end
