class RemoveCustomerInfoFromProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :customer_info, :string
  end
end
