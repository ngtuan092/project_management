class LessonLearn < ApplicationRecord
  belongs_to :lesson_learn_category
  belongs_to :creator, class_name: User.name
  belongs_to :project, optional: true

  validates :context_description, presence: true,
            length: {maximum: Settings.digits.length_3000}
  validates :learning_point, presence: true,
            length: {maximum: Settings.digits.length_3000}
  validates :reference_link,
            length: {maximum: Settings.digits.length_3000}
  validates :reference_process,
            length: {maximum: Settings.digits.length_3000}
end
