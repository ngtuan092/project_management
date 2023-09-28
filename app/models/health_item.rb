class HealthItem < ApplicationRecord
  acts_as_paranoid

  HEALTH_ITEM_PARAMS = [
    :item, :description, :is_enabled
  ].freeze

  has_many :project_health_items, dependent: :destroy
  has_many :projects, through: :project_health_items

  scope :enable_items, ->{where is_enabled: true}
  scope :filter_name, lambda {|name|
    where("item LIKE ?", "%#{name}%") if name.present?
  }

  def can_destroy_health_item?
    project_health_items.all?(&:status_not_apply?) || projects.empty?
  end
end
