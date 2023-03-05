class UsersSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscription
  belongs_to :question, touch: true
end
