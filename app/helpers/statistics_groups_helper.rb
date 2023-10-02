module StatisticsGroupsHelper
  include ValueResourcesHelper

  def group_month_service
    if boolean_params(:each_month_separately)
      GroupMonthSeparatelyAnalyzer
    else
      GroupMonthAnalyzer
    end
  end

  def group_statistic_html group, start_month_year, end_month_year
    if boolean_params(:average_month)
      hash_month = GroupMonthAverageAnalyzer
                   .call(group, start_month_year, end_month_year,
                         boolean_params(:each_month_separately))
                   .result
      return value_resource_hash_to_html hash_month, :td
    end
    hash_month = group_month_service.call(group, start_month_year,
                                          end_month_year)
                                    .result
    value_resource_hash_to_html hash_month, :td
  end
end
