class Group < ApplicationRecord
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :projects, through: :users
  belongs_to :parent, class_name: Group.name, optional: true
  has_many :sub_groups, class_name: Group.name, foreign_key: :parent_id,
           dependent: :destroy
end
