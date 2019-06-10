module Statistics
  class Assignments

    attr_accessor :organization, :interval, :date_range

    def initialize(date_range, interval, organization)
      @organization = organization
      @interval = interval
      @date_range = date_range
    end

    def call
      get_grouped_data
    end

    def jobs_ids
      ids = Broker.first.jobs.where(created_at: (date_range[0]..date_range[-1])).uniq.pluck(:id).join(',')
      if ids.present?
        jobs = "(#{Broker.first.jobs.where(created_at: (date_range[0]..date_range[-1])).uniq.pluck(:id).join(',')})"
        return "AND assignments.job_id IN #{jobs}"
      else
        return "AND 0=1"
      end
    end

    def get_grouped_data
      sql = "
        SELECT date_trunc('#{interval}', created_at) AS \"date_interval\" , count(*) AS \"records_number\"
        FROM assignments
        WHERE created_at BETWEEN '#{date_range[0]}' AND '#{date_range[-1]}' #{jobs_ids}
        GROUP BY 1
        ORDER BY 1;
      "
      records_array = ActiveRecord::Base.connection.execute(sql)
      Statistics::Dataset.new(records_array, 'rgba(140,160,255,1)', 'Assignments').call
    end
  end
end