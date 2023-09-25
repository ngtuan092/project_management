class CreateReleasePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :release_plans do |t|
      t.references :project, null: false, foreign_key: true
      t.references :creator, foreign_key: {to_table: :users}, null: false
      t.text :description
      t.boolean :is_released, null: false
      t.datetime :release_date
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
