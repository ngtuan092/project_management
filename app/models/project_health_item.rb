class ProjectHealthItem < ApplicationRecord
  belongs_to :project
  belongs_to :health_item
end
