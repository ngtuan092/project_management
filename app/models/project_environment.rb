class ProjectEnvironment < ApplicationRecord
  belongs_to :project
  enum environment: {staging: 0, production: 1}
  validates :environment, presence: true, inclusion: {in: environments.keys}
  validates :ip_address, presence: true
  validates :port, presence: true
end
