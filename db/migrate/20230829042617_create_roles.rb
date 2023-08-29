class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.text :description
      t.integer :role_type, null: false

      t.timestamps
    end
  end
end
