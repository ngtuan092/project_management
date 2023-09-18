class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  class << self
    def valid_date date_str
      return nil if date_str.blank?

      Date.parse(date_str) || Time.zone.parse(date_str)
    rescue ArgumentError
      nil
    end
  end
end
