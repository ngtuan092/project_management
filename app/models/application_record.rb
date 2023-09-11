class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  class << self
    def valid_date date_str
      Date.parse date_str
    rescue ArgumentError
      nil
    end
  end
end
