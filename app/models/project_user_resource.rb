class ProjectUserResource < ApplicationRecord
  belongs_to :project_user

  validates :percentage, :month, :year, :man_month,
            presence: true
end
