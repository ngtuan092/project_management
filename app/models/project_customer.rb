class ProjectCustomer < ApplicationRecord
  belongs_to :customer
  belongs_to :project
end
