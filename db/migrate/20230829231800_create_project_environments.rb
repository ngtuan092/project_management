class CreateProjectEnvironments < ActiveRecord::Migration[7.0]
  def change
    create_table :project_environments do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :environment, null: false
      t.string :ip_address, null: false
      t.integer :port, null: false
      t.string :domain
      t.string :web_server
      t.text :note
      t.datetime :delete_at

      t.timestamps
    end
  end
end
