class AddAuthorToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_reference :answers, :author, foreign_key: { to_table: :users }
  end
end
