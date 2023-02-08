class CreateUserSubscriptions < ActiveRecord::Migration[6.1]
  def up
    create_table :users_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end

    subscription = Subscription.find_by(slug: "new_answer")
    Question.find_each do |question|
      question.author.users_subscriptions.create!(subscription_id: subscription.id, question_id: question.id)
    end
  end

  def down
    drop_table :users_subscriptions
  end
end
