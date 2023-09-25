class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :avatar, null: false
      t.string :remember_digest
      t.string :slack_id
      t.string :git_account
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
