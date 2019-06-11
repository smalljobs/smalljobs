module Statistics
  class Providers < StatisticObject
    def organization_ids
      jobs = "(#{organization.join(',')})"
      return "organization_id IN #{jobs}"
    end
    def get_grouped_data
      sql = "
        SELECT date_trunc('#{options[:interval]}', created_at) AS \"date_interval\" , count(*) AS \"records_number\"
        FROM providers
        WHERE created_at BETWEEN '#{date_range[0]}' AND '#{date_range[-1]}'  AND #{organization_ids}
        GROUP BY 1
        ORDER BY 1;
      "
      records_array = ActiveRecord::Base.connection.execute(sql)
      if options[:sum_type] == 'all'
        records_array = get_summed_records(records_array)
      end
      Statistics::Dataset.new(records_array, 'rgba(99,255,132,1)', 'Providers').call
    end
  end
end