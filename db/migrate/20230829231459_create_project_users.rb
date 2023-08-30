class CreateProjectUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :project_users do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :project_role, foreign_key: { to_table: :roles }, null: false
      t.datetime :joined_at
      t.datetime :left_at
    end
  end
end
