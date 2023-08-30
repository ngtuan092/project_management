class CreateProjectUserResources < ActiveRecord::Migration[7.0]
  def change
    create_table :project_user_resources do |t|
      t.references :project_user, null: false, foreign_key: true
      t.integer :percentage, null: false
      t.integer :month, null: false
      t.integer :year, null: false
      t.float :man_month, null: false
    end
  end
end
