class CreateConfirmedEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :confirmed_emails do |t|
      t.string :email, null: false
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :confirmation_token, null: false

      t.timestamps
    end

    add_index :confirmed_emails, [:provider, :uid, :email]
  end
end
