class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :project_role, class_name: Role.name
  has_many :project_user_resources, dependent: :destroy

  delegate :name, :git_account, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :project_role, prefix: true, allow_nil: true

  scope :by_earliest_joined, ->{order :joined_at}
end
