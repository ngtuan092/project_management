class AddReleasedAtToReleasePlan < ActiveRecord::Migration[7.0]
  def change
    add_column :release_plans, :released_at, :datetime
  end
end
