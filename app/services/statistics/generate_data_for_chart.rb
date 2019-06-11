module Statistics
  class GenerateDataForChart
    attr_accessor :organization, :options, :date_range

    def initialize(date_range, organization, options)
      @organization = organization
      @date_range = date_range
      @options = options
    end

    def call
      generate_data
    end

    def generate_data
      {
          datasets: [
            Statistics::Seekers.new(date_range, organization, options).call,
            Statistics::Providers.new(date_range, organization, options).call,
            Statistics::Jobs.new(date_range, organization, options).call,
            Statistics::Assignments.new(date_range, organization, options).call,
            Statistics::Allocations.new(date_range, organization, options).call
          ],
          labels: labels,
      }
    end

    def labels
      self.respond_to?(options[:interval]) ? send(options[:interval]) : self.month
    end

    def day
      (date_range[0]..date_range[-1]).to_a.map{|d| d.strftime("%Y-%m-%d")}
    end

    def week
      get_range('week')
    end

    def month
      get_range('month')
    end

    def year
      get_range('year')
    end

    def get_range interval
      (date_range[0].send("beginning_of_#{interval}")..date_range[-1].send("beginning_of_#{interval}"))
        .to_a
        .select{|d| d == d.send("beginning_of_#{interval}")}
        .map{|d|d.strftime("%Y-%m-%d")}
    end

  end
end