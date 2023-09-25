class ReleasePlan < ApplicationRecord
  UPDATE_ATTRS = [
    :project_id, :description,
    :is_released, :release_date, :released_at
  ].freeze

  belongs_to :project
  belongs_to :creator, class_name: User.name

  delegate :name, to: :project, prefix: true
  delegate :name, :email, to: :creator, prefix: true

  enum is_released: {released: true,
                     preparing: false},
       _prefix: true

  validates :release_date, presence: true
  validates :description, presence: true,
            length: {maximum: Settings.project.max_length_200}
  validates :is_released, presence: true
  validate :check_is_released

  scope :in_date_range, lambda {|date_from, date_to|
    if date_from.present? && date_to.present? && valid_date(date_from) &&
       valid_date(date_to)
      where(release_date: date_from..date_to)
    elsif date_from.present? && valid_date(date_from)
      where("release_date >= ?", date_from)
    elsif date_to.present? && valid_date(date_to)
      where("release_date <= ?", date_to)
    else
      all
    end
  }
  scope :filter_status, ->(status){where is_released: status if status.present?}
  scope :filter_name, lambda {|name|
    ids = Project.filter_name(name).pluck :id
    where(project_id: ids)
  }

  private
  def check_is_released
    return unless is_released_released?

    return if released_at.present?

    errors.add(:released_at, I18n.t("release_plans.validate_released_at"))
  end
end
