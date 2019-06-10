module Statistics
  class GenerateDataForChart
    attr_accessor :interval, :date_range, :organization
    def initialize(date_range, interval, organization)
      @interval = interval
      @date_range = date_range
      @organization = organization
    end

    def call
      generate_data
    end

    def generate_data
      {
          datasets: [
            Statistics::Seekers.new(date_range, interval, organization).call,
            Statistics::Providers.new(date_range, interval, organization).call,
            Statistics::Jobs.new(date_range, interval, organization).call,
            Statistics::Assignments.new(date_range, interval, organization).call,
            Statistics::Allocations.new(date_range, interval, organization).call
          ],
          labels: labels,
      }
    end

    def labels
      self.respond_to?(interval) ? send(interval) : self.month
    end

    def day
      date_range.to_a.map{|d| d.strftime("%Y-%m-%d")}
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