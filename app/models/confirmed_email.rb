class ConfirmedEmail < ApplicationRecord
  validates :email, :provider, :uid, :confirmation_token, presence: true

  def self.find(confirmed_email)
    ConfirmedEmail.where(
      provider: confirmed_email[:provider],
      uid: confirmed_email[:uid],
      email: confirmed_email[:email]
    ).first
  end
end
