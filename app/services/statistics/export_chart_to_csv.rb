module Statistics
  class ExportChartToCsv
    attr_accessor :organization, :options, :date_range, :jobs_ids, :chart_data, :labels, :datasets

    def initialize(date_range, organization, options)
      @organization = organization
      @date_range = date_range
      @options = options
    end

    def call
      to_csv
    end

    def generate_data
      @chart_data = Statistics::GenerateDataForChart.new(date_range, organization, options).call
    end

    def get_data
      @datasets ||= chart_data[:datasets]
    end

    def get_labels
      @labels ||= chart_data[:labels]
    end

    def generate_structure_for_csv
      generate_data
      arr = [['Date', get_data.map{|x| x[:label] }].flatten]
      get_labels.each do |x|
        sub_arr = [x]
        get_data.each do |data|
          sub_arr << data[:data].select{ |hash| hash[:x] == x}[0].try('[]', :y)
        end
        arr << sub_arr
      end
      arr
    end

    def to_csv
      attributes = generate_structure_for_csv
      CSV.generate(headers: true) do |csv|
        attributes.each do |attr|
          csv << attr
        end
      end
    end

  end
end