class LessonLearn < ApplicationRecord
  UPDATE_ATTRS = [
    :lesson_learn_category_id, :project_id, :context_description,
    :learning_point, :reference_process, :reference_link
  ].freeze

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

  delegate :name, to: :lesson_learn_category, prefix: true
  delegate :name, to: :creator, prefix: true
  delegate :name, to: :project, prefix: true

  scope :filter_lesson_category, lambda {|lesson_learn_category_id|
    where(lesson_learn_category_id:) if lesson_learn_category_id.present?
  }
  scope :filter_creator, lambda {|creator_id|
    where(creator_id:) if creator_id.present?
  }
end
