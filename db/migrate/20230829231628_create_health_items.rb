class CreateHealthItems < ActiveRecord::Migration[7.0]
  def change
    create_table :health_items do |t|
      t.string :item, null: false
      t.text :description
      t.boolean :is_enabled, null: false, default: false
      t.datetime :delete_at

      t.timestamps
    end
  end
end
