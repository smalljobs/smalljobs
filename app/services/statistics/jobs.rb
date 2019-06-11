module Statistics
  class Jobs < StatisticObject
    def organization_ids
      jobs = "(#{organization.join(',')})"
      return "organization_id IN #{jobs}"
    end

    def state
      if is_true?(options[:active]) && is_true?(options[:archived])
        ''
      elsif is_true?(options[:active]) && is_false?(options[:archived])
        'AND state != \'finished\''
      elsif is_false?(options[:active]) && is_true?(options[:archived])
        'AND state = \'finished\''
      elsif is_false?(options[:active]) && is_false?(options[:archived])
        'AND 0=1'
      end
    end

    def is_true?(option)
      option == 'true'
    end

    def is_false?(option)
      !is_true?(option)
    end

    def get_grouped_data
      sql = "
        SELECT date_trunc('#{options[:interval]}', created_at) AS \"date_interval\" , count(*) AS \"records_number\"
        FROM jobs
        WHERE created_at BETWEEN
        '#{date_range[0]}' AND
        '#{date_range[-1]}' AND
        #{organization_ids}
        #{state}
        GROUP BY 1
        ORDER BY 1;
      "
      records_array = ActiveRecord::Base.connection.execute(sql)
      if options[:sum_type] == 'all'
        records_array = get_summed_records(records_array)
      end
      Statistics::Dataset.new(records_array, 'rgba(0,0,255,1)', 'Job').call
    end
  end
end