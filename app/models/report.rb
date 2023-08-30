class Report < ApplicationRecord
  belongs_to :project
  belongs_to :user
end
