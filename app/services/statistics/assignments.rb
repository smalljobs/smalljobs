module Statistics
  class Assignments < StatisticObject

    def initialize(date_range, organization, options)
      super
      @jids = options[:jobs_ids]
    end

    def jobs_ids
      ids = @jids
      if ids.present?
        jobs = "(#{ids.join(',')})"
        return "AND assignments.job_id IN #{jobs}"
      else
        return "AND 0=1"
      end
    end

    def get_grouped_data
      sql = "
        SELECT date_trunc('#{options[:interval]}', created_at) AS \"date_interval\" , count(*) AS \"records_number\"
        FROM assignments
        WHERE created_at BETWEEN '#{date_range[0]}' AND '#{date_range[-1]}' #{jobs_ids}
        GROUP BY 1
        ORDER BY 1;
      "
      records_array = ActiveRecord::Base.connection.execute(sql)
      records_array = populate_with_zeros(records_array)
      if options[:sum_type] == 'all'
        records_array = get_summed_records(records_array)
      end
      records_array = format_array(records_array)
      Statistics::Dataset.new(records_array, 'rgba(99,132,255,1)', 'Anstellungen').call
    end
  end
end