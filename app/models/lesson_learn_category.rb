class LessonLearnCategory < ApplicationRecord
  has_many :lesson_learns, dependent: nil

  validates :name, presence: true,
            length: {maximum: Settings.digits.length_200}
end
