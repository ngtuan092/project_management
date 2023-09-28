class AddRubatoIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :rubato_id, :string
  end
end
