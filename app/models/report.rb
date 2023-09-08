class Report < ApplicationRecord
  UPDATE_ATTRS = [
    :date, :project_id, :description,
    :resource_description, :issue
  ].freeze

  belongs_to :project
  belongs_to :user

  validates :date, presence: true
  validates :project_id, presence: true
  validates :description, presence: true,
            length: {maximum: Settings.project.max_length_1000}
  validates :resource_description, presence: true,
            length: {maximum: Settings.project.max_length_200}
  validates :issue, presence: true,
            length: {maximum: Settings.project.max_length_200}
end
