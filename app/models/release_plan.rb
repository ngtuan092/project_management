class ReleasePlan < ApplicationRecord
  UPDATE_ATTRS = [
    :project_id, :description,
    :is_released, :release_date
  ].freeze

  belongs_to :project
  belongs_to :creator, class_name: User.name

  delegate :name, to: :project, prefix: true

  enum is_released: {released: true,
                     preparing: false},
       _prefix: true

  validates :release_date, presence: true
  validates :description, presence: true,
            length: {maximum: Settings.project.max_length_200}
  validates :is_released, presence: true

  scope :filter_date, ->(date){filter_by_date(date) if date.present?}
  scope :filter_status, ->(status){where is_released: status if status.present?}
  scope :filter_name, lambda {|name|
    ids = Project.filter_name(name).pluck :id
    where(project_id: ids)
  }
  class << self
    def filter_by_date date_str
      date = valid_date date_str
      date ? where(release_date: date) : all
    end
  end
end
