class ProjectFeature < ApplicationRecord
  belongs_to :project

  enum repeat_unit: {day: 0, week: 1, month: 2, quarter: 3, half_a_year: 4,
                     year: 5}, _prefix: true
end
