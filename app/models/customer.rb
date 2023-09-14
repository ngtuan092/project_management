class Customer < ApplicationRecord
  has_many :project_customers, dependent: :destroy
  has_many :projects, through: :project_customers

  scope :by_id, ->(id){where id: id if id.present?}
end
