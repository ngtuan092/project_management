class CreateRoleUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :role_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
    end
  end
end
