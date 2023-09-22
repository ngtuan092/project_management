class Report < ApplicationRecord
  UPDATE_ATTRS = [
    :date, :project_id, :description,
    :resource_description, :issue
  ].freeze

  belongs_to :project
  belongs_to :user

  delegate :name, to: :project, prefix: true
  delegate :name, :email, to: :user, prefix: true

  validates :date, presence: true
  validates :project_id, presence: true
  validates :description, presence: true,
            length: {maximum: Settings.project.max_length_1000}
  validates :resource_description, presence: true,
            length: {maximum: Settings.project.max_length_200}
  validates :issue, presence: true,
            length: {maximum: Settings.project.max_length_200}

  scope :filter_start_date, lambda {|start_date|
    where("date >= ?", start_date) if start_date.present? &&
                                      valid_date(start_date)
  }

  scope :filter_end_date, lambda {|end_date|
    where("date <= ?", end_date) if end_date.present? &&
                                    valid_date(end_date)
  }

  scope :filter_name_status, lambda {|name, status|
    ids = Project.filter_name(name)
                 .filter_status(status).pluck :id
    where(project_id: ids)
  }
end
