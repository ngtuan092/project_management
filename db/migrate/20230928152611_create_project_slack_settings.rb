class CreateProjectSlackSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :project_slack_settings do |t|
      t.references :project, null: false, foreign_key: true
      t.string :slack_room
      t.string :slack_mention
      t.boolean :send_release, default: false
      t.boolean :send_value, default: false
      t.boolean :send_resource, default: false
      t.timestamps
    end
  end
end
