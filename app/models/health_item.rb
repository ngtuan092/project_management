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

  scope :unchecked_health_items, lambda {|project_id|
    project = Project.find_by id: project_id
    checked_item_ids = project.project_health_items.pluck(:health_item_id)
    all_items_ids = HealthItem.enable_items.pluck(:id)
    not_check_items = all_items_ids - checked_item_ids
    where id: not_check_items
  }

  def can_destroy_health_item?
    project_health_items.all?(&:status_not_apply?) || projects.empty?
  end
end
