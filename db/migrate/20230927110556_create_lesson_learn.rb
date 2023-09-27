class CreateLessonLearn < ActiveRecord::Migration[7.0]
  def change
    create_table :lesson_learns do |t|
      t.references :lesson_learn_category, null: false, foreign_key: true
      t.text :context_description, null: false
      t.text :learning_point, null: false
      t.text :reference_link
      t.text :reference_process
      t.references :creator, foreign_key: { to_table: :users }, null: false
      t.references :project, null: true, foreign_key: true

      t.timestamps
    end
  end
end
