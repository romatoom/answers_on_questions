class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def up
    create_table :subscriptions do |t|
      t.string :title, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :subscriptions, :slug, unique: true

    Subscription.create!(title: 'New answer to the question', slug: 'new_answer')
    Subscription.create!(title: 'Question has been changed', slug: 'change_question')
  end

  def down
    drop_table :subscriptions
  end
end
