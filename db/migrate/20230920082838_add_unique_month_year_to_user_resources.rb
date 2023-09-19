class AddUniqueMonthYearToUserResources < ActiveRecord::Migration[7.0]
  def change
    add_index :project_user_resources, [:project_user_id, :month, :year], unique: true, name: "idx_pur_on_pu_month_year"
  end
end
