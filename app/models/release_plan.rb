class ReleasePlan < ApplicationRecord
  UPDATE_ATTRS = [
    :project_id, :description,
    :is_released, :release_date
  ].freeze

  belongs_to :project

  enum is_released: {released: true,
                     preparing: false},
       _prefix: true

  validates :release_date, presence: true
  validates :description, presence: true,
            length: {maximum: Settings.project.max_length_200}
  validates :is_released, presence: true
end
