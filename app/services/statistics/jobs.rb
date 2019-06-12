module Statistics
  class Jobs < StatisticObject
    def organization_ids
      jobs = "(#{organization.join(',')})"
      return "jobs.organization_id IN #{jobs}"
    end

    def state
      if is_true?(options[:active]) && is_true?(options[:archived])
        ''
      elsif is_true?(options[:active]) && is_false?(options[:archived])
        'AND jobs.state != \'finished\''
      elsif is_false?(options[:active]) && is_true?(options[:archived])
        'AND jobs.state = \'finished\''
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
        SELECT date_trunc('#{options[:interval]}', jobs.created_at) AS \"date_interval\" , count(*) AS \"records_number\"
        FROM jobs
        INNER JOIN providers ON jobs.provider_id = providers.id
        INNER JOIN places ON providers.place_id = places.id
        WHERE jobs.created_at BETWEEN
        '#{date_range[0]}' AND
        '#{date_range[-1]}' AND
        #{organization_ids}
        #{state} AND
        places.region_id = #{options[:region_id]}
        GROUP BY 1
        ORDER BY 1;
      "
      records_array = ActiveRecord::Base.connection.execute(sql)
      if options[:sum_type] == 'all'
        records_array = get_summed_records(records_array)
      end
      records_array = format_array(records_array)
      Statistics::Dataset.new(records_array, 'rgba(0,0,255,1)', 'Jobs').call
    end
  end
end