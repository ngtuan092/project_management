class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.datetime :date, null: false
      t.text :description, null: false
      t.text :resource_description, null: false
      t.text :issue, null: false
      t.datetime :delete_at

      t.timestamps
    end
  end
end
