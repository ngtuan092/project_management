class CreateProjectHealthItems < ActiveRecord::Migration[7.0]
  def change
    create_table :project_health_items do |t|
      t.references :project, null: false, foreign_key: true
      t.references :health_item, null: false, foreign_key: true
      t.text :note
      t.integer :status, null: false
    end
  end
end
