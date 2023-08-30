class CreateProjectCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :project_customers do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
    end
  end
end
