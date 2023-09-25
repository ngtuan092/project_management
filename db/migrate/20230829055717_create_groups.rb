class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.text :description
      t.integer :parent_id
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
