class ProjectFeature < ApplicationRecord
  PROJECT_FEATURE_PARAMS = [
    :name, :description, :month,
    :year, :date, :waste_description,
    :effort_saved, :repeat_time,
    :repeat_unit
  ].freeze

  belongs_to :project

  enum repeat_unit: {day: 0, week: 1, month: 2, quarter: 3, half_a_year: 4,
                     year: 5}, _prefix: true

  validates :name, presence: true,
            length: {maximum: Settings.digits.length_200}
  validates :description, presence: true,
            length: {maximum: Settings.digits.length_1000}
  validates :month, presence: true
  validates :year, presence: true
  validates :waste_description, presence: true,
            length: {maximum: Settings.digits.length_1000}
  validates :effort_saved, presence: true
  validates :repeat_time, presence: true
  validates :repeat_unit, presence: true, inclusion: {in: repeat_units.keys}
  validates :man_month, presence: true
  validate :valid_month?, :valid_year?

  before_validation :add_man_month_before_save

  scope :filter_month, ->(month){where(month:) if month}
  scope :filter_year, ->(year){where(year:) if year}

  def effort_hour_month_save
    total_hour = effort_saved * repeat_time
    case repeat_unit.to_sym
    when :day then total_hour * 22
    when :week then total_hour * 4
    when :month then total_hour
    when :quarter then total_hour / 4
    when :half_a_year then total_hour / 6
    when :year then total_hour / 12
    else 0 end
  end

  def calculator_man_month
    effort_hour_month_save / (22 * 8)
  end

  private
  def add_man_month_before_save
    self.man_month = calculator_man_month
  end

  def valid_month?
    unless Date.valid_date? Time.zone.now.year, month, Settings.digits.length_1
      errors.add :month, I18n.t("validates.errors.month")
    end
  end

  def valid_year?
    unless Date.valid_date? year, Time.zone.now.month, Settings.digits.length_1
      errors.add :month, I18n.t("validates.errors.year")
    end
  end
end
