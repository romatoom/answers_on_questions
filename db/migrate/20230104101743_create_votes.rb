class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :voteable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
