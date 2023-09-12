class Project < ApplicationRecord
  attr_accessor :month_year, :project_id

  PROJECT_PARAMS = [
    :name, :description, :status, :start_date,
    :end_date, :group_id, :language,
    :repository, :redmine,
    :project_folder, :customers,
    :creator_id,
    {
      project_environments_attributes: [
        :environment, :domain, :port,
        :ip_address, :web_server,
        :note, :_destroy
      ]
    }
  ].freeze

  PROJECT_FEATURE_PARAMS = [
    :month_year, :project_id,
    {
      project_features_attributes:
        [
          :name, :description,
          :waste_description,
          :effort_saved, :repeat_time,
          :repeat_unit, :_destroy
        ]
    }
  ].freeze

  belongs_to :group
  belongs_to :creator, class_name: User.name

  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :reports, dependent: :destroy
  has_many :project_customers, dependent: :destroy
  has_many :customers, through: :project_customers
  has_many :release_plans, dependent: :destroy
  has_many :project_environments, dependent: :destroy
  has_many :project_features, dependent: :destroy
  has_many :project_health_items, dependent: :destroy
  has_many :health_items, through: :project_health_items
  has_many :project_user_resources, through: :project_users

  delegate :name, to: :group, prefix: true
  enum status: {new: 0, in_progress: 1, maintaining: 2, pending: 3, close: 4},
       _prefix: true
  accepts_nested_attributes_for :project_environments, allow_destroy: true,
                                                       reject_if: :all_blank
  accepts_nested_attributes_for :project_features, allow_destroy: true,
                                                   reject_if: :all_blank

  validates :name, presence: true,
                   length: {maximum: Settings.project.max_length_200}
  validates :description, length: {maximum: Settings.project.max_length_1000}
  validates :status, presence: true, inclusion: {in: statuses.keys}
  validates :group_id, presence: true
  validates :language, presence: true
  validates :repository, length: {maximum: Settings.project.max_length_200}
  validates :redmine, length: {maximum: Settings.project.max_length_200}
  validates :project_folder, length: {maximum: Settings.project.max_length_200}
  validates :month_year, format: {with: Settings.month_year.regex,
                                  message: I18n.t("message_valid_month_year")}

  scope :filter_name, lambda {|name|
    where("name LIKE ?", "%#{name}%") if name.present?
  }
  scope :filter_date, lambda {|date|
                        where("start_date LIKE ?", "#{date}%") if date.present?
                      }
  scope :filter_status, ->(status){where status: status if status.present?}
  scope :filter_group, ->(group){where group_id: group if group.present?}
  scope :filter_features, lambda {|month, year|
    includes(:project_features)
      .joins(:project_features)
      .merge(ProjectFeature.filter_month(month))
      .merge(ProjectFeature.filter_year(year))
  }
  scope :created_by_user_or_psm, lambda {|current_user|
    where(creator_id: current_user.id)
      .or(
        where(
          id: ProjectUser
            .where(
              user_id: current_user.id,
              project_role_id: Role.find_by(name: Settings.project_roles.PSM)
            )
            .select(:project_id)
        )
      )
  }

  def calculate_project_man_per_month date
    year, month = date&.split("-")
    year ||= Time.zone.now.year
    month ||= Time.zone.now.month
    project_features = self.project_features
                           .filter_month(month)
                           .filter_year(year)
    man_month = project_features.reduce(0){|a, e| a + e.calculator_man_month}
    man_month.round Settings.digits.length_2
  end

  def sum_man_month
    project_user_resources.sum(:man_month)
  end
end
