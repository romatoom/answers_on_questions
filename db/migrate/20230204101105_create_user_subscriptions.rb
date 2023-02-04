class CreateUserSubscriptions < ActiveRecord::Migration[6.1]
  def up
    create_table :users_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.boolean :active, default: false

      t.timestamps
    end

    Question.find_each do |question|
      SubscriptionService.new.create_subscription_for_user(
        user: question.author, subscription_slug: "new_answer", question: question
      )
    end
  end

  def down
    drop_table :users_subscriptions
  end
end
