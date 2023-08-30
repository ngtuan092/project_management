class CreateProjectFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :project_features do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :month, null: false
      t.integer :year, null: false
      t.text :waste_description
      t.float :effort_saved, null: false
      t.float :repeat_time, null: false
      t.integer :repeat_unit, null: false
      t.float :man_month, null: false
      t.datetime :delete_at

      t.timestamps
    end
  end
end
