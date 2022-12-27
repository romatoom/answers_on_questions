class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :title
      t.references :user
      t.references :question, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
