class CreateLessonLearnCategory < ActiveRecord::Migration[7.0]
  def change
    create_table :lesson_learn_categories do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
