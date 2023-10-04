class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :by_earliest_created, ->{order(created_at: :asc)}
  scope :by_recently_created, ->{order(created_at: :desc)}
  scope :filter_start_date, lambda {|start_date|
    where("created_at >= ?", start_date) if start_date.present? &&
                                            valid_date(start_date)
  }
  scope :filter_end_date, lambda {|end_date|
    if end_date.present? && valid_date(end_date)
      where("created_at <= ?", end_date.to_date.end_of_day)
    end
  }

  class << self
    def valid_date date_str
      return nil if date_str.blank?

      Date.parse(date_str) || Time.zone.parse(date_str)
    rescue ArgumentError
      nil
    end
  end
end
