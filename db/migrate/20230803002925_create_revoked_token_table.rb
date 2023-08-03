class CreateRevokedTokenTable < ActiveRecord::Migration[7.0]
  def change
    create_table :revoked_jwt_tokens do |t|
      t.text :token, index: true

      t.timestamps
    end
  end
end
