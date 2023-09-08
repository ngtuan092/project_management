class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.references :group, null: false, foreign_key: true
      t.references :creator, foreign_key: { to_table: :users }, null: false
      t.string :name, null: false
      t.text :description
      t.integer :status, null: false
      t.datetime :start_date
      t.datetime :end_date
      t.text :repository
      t.text :redmine
      t.text :project_folder
      t.string :language, null: false
      t.datetime :delete_at

      t.timestamps
    end
  end
end
