class User < ApplicationRecord
  has_many :role_users, dependent: :destroy
  has_many :roles, through: :role_users
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :reports, dependent: :destroy
end
