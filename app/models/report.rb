class Report < ApplicationRecord
  UPDATE_ATTRS = [
    :date, :project_id, :description,
    :resource_description, :issue
  ].freeze

  belongs_to :project
  belongs_to :user

  delegate :name, to: :project, prefix: true

  validates :date, presence: true
  validates :project_id, presence: true
  validates :description, presence: true,
            length: {maximum: Settings.project.max_length_1000}
  validates :resource_description, presence: true,
            length: {maximum: Settings.project.max_length_200}
  validates :issue, presence: true,
            length: {maximum: Settings.project.max_length_200}

  scope :filter_date, ->(date){filter_by_date(date) if date.present?}

  scope :filter_name_status, lambda {|name, status|
    ids = Project.filter_name(name)
                 .filter_status(status).pluck :id
    where(project_id: ids)
  }
  class << self
    def filter_by_date date_str
      date = valid_date date_str
      date ? where(date:) : all
    end
  end
end
