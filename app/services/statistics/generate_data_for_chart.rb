module Statistics
  class GenerateDataForChart
    attr_accessor :organization, :options, :date_range, :jobs_ids

    def initialize(date_range, organization, options)
      @organization = organization
      @date_range = date_range
      @options = options
      @jobs_ids = get_jobs_ids
    end

    def call
      generate_data
    end

    def get_jobs_ids
      Statistics::GetJobsIds.new(date_range, organization, options).call
    end

    def generate_data
      {
          datasets: [
            Statistics::Seekers.new(date_range, organization, options).call,
            Statistics::Providers.new(date_range, organization, options).call,
            Statistics::Jobs.new(date_range, organization, options).call,
            Statistics::Assignments.new(date_range, organization, options.merge({jobs_ids: @jobs_ids})).call,
            Statistics::Allocations.new(date_range, organization, options.merge({jobs_ids: @jobs_ids})).call
          ],
          labels: labels,
      }
    end

    def labels
      self.respond_to?(options[:interval]) ? send(options[:interval]) : self.month
    end

    def day
      (date_range[0]..date_range[-1]).to_a.map{|d| d.to_date.strftime("%Y-%m-%d")}
    end

    def week
      get_range('week').map{|d|d.to_date.strftime("%Y-%m-%d")}
    end

    def month
      get_range('month').map{|d|d.to_date.strftime("%Y-%m")}
    end

    def year
      get_range('year').map{|d|d.to_date.strftime("%Y")}
    end

    def get_range interval
      (date_range[0].send("beginning_of_#{interval}")..date_range[-1].send("beginning_of_#{interval}"))
        .to_a
        .select{|d| d == d.send("beginning_of_#{interval}")}
    end

  end
end