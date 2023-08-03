class CreateUserTable < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.datetime :email_confirmed_at
      t.text :password_digest
      t.text :confirmation_token, index: true
      t.text :otp_secret
      t.bigint :last_otp_at
      t.boolean :is_two_factor_enabled, null: false, default: true
      t.text :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
