class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :project_role, class_name: Role.name
  has_many :project_user_resources, dependent: :destroy
end
