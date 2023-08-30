class Permission < ApplicationRecord
  has_many :permission_roles, dependent: :destroy
  has_many :roles, through: :permission_roles
end
