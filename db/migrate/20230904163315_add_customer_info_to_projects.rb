class AddCustomerInfoToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :customer_info, :string
  end
end
