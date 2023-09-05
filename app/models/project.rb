class Project < ApplicationRecord
  PROJECT_PARAMS = [
    :name, :description, :status, :start_date,
    :end_date, :group_id, :language,
    :repository, :redmine,
    :project_folder, :customer_info,
    {
      project_environments_attributes: [
        :environment, :domain, :port,
        :ip_address, :web_server,
        :note, :_destroy
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
  delegate :name, to: :group, prefix: true
  enum status: {new: 0, in_progress: 1, maintaining: 2, pending: 3, close: 4},
       _prefix: true
  accepts_nested_attributes_for :project_environments, allow_destroy: true,
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
  validates :customer_info, length: {maximum: Settings.project.max_length_1000}

  scope :filter_name, lambda {|name|
    where("name LIKE ?", "%#{name}%") if name.present?
  }
  scope :filter_date, ->(date){filter_by_date(date) if date.present?}
  scope :filter_status, ->(status){where status: status if status.present?}
  scope :filter_group, ->(group){where group_id: group if group.present?}

  class << self
    def filter_by_date date_str
      date = valid_date date_str
      date.present? ? where(start_date: date) : all
    end

    def valid_date date_str
      Date.parse date_str
    rescue ArgumentError
      nil
    end
  end
end
