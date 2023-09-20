class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :by_recently_created, ->{order(created_at: :desc)}

  class << self
    def valid_date date_str
      return nil if date_str.blank?

      Date.parse(date_str) || Time.zone.parse(date_str)
    rescue ArgumentError
      nil
    end
  end
end
