class ConfirmedEmail < ApplicationRecord
  validates :email, :provider, :uid, :confirmation_token, presence: true
end
