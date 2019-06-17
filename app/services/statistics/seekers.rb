module Statistics
  class Seekers < StatisticObject

    def organization_ids
      jobs = "(#{organization.join(',')})"
      return "organization_id IN #{jobs}"
    end

    def status
      if is_true?(options[:active]) && is_true?(options[:archived])
        ''
      elsif is_true?(options[:active]) && is_false?(options[:archived])
        'AND seekers.status != 3'
      elsif is_false?(options[:active]) && is_true?(options[:archived])
        'AND seekers.status = 3'
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
        SELECT date_trunc('#{options[:interval]}', seekers.created_at) AS \"date_interval\" , count(*) AS \"records_number\"
        FROM seekers
        INNER JOIN places ON seekers.place_id = places.id
        WHERE seekers.created_at BETWEEN
        '#{date_range[0]}' AND
        '#{date_range[-1]}' AND
        #{organization_ids}
        #{status} AND
        places.region_id = #{options[:region_id]}
        GROUP BY 1
        ORDER BY 1;
      "
      records_array = ActiveRecord::Base.connection.execute(sql)
      records_array = populate_with_zeros(records_array)
      if options[:sum_type] == 'all'
        records_array = get_summed_records(records_array)
      end
      records_array = format_array(records_array)
      Statistics::Dataset.new(records_array, 'rgba(255,99,132,1)', 'Jugendliche').call
    end
  end
end