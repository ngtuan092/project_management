class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :name, null: false
      t.text :description
      t.integer :permission_type, null: false

      t.timestamps
    end
  end
end
