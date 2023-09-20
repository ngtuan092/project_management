class HealthItem < ApplicationRecord
  has_many :project_health_items, dependent: :destroy
  has_many :projects, through: :project_health_items

  scope :enable_items, ->{where is_enabled: true}
  scope :filter_name, lambda {|name|
    where("item LIKE ?", "%#{name}%") if name.present?
  }
end
