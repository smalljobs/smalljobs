module Statistics
  class StatisticObject

    attr_accessor :organization, :options, :date_range

    def initialize(date_range, organization, options)
      @organization = organization
      @date_range = date_range
      @options = options
    end

    def call
      get_grouped_data
    end

    def get_summed_records records_array
      rec_arr = records_array.to_a
      records_array = []
      rec_arr.each_with_index.map do |x, y|
        records_array << {
            'date_interval' => x['date_interval'],
            'records_number' => rec_arr[0..y].sum{|s| s['records_number']},
        }
      end
      records_array
    end

    def format_array(records_array)
      arr = []
      if options[:interval] == 'year'
        records_array.each do |record|
          arr << {
              'date_interval' => record['date_interval'].to_date.strftime("%Y"),
              'records_number' => record['records_number']
          }
        end
      elsif options[:interval] == 'month'
        records_array.each do |record|
          arr << {
              'date_interval' => record['date_interval'].to_date.strftime("%m-%Y"),
              'records_number' => record['records_number']
          }
        end
      else
        records_array.each do |record|
          arr << {
              'date_interval' => record['date_interval'].to_date.strftime("%d-%m-%Y"),
              'records_number' => record['records_number']
          }
        end
      end
      arr
    end

    def populate_with_zeros(records_array)
      rec_arr = records_array.to_a
      arr_of_dates = get_range(options[:interval])
      arr_of_dates.each_with_index do |date, index|
        unless rec_arr.select{|x| x['date_interval'].to_date == date}.present?
          rec_arr.insert(index, {'date_interval' => date.to_datetime.strftime("%Y-%m-%d %H:%M:%S"), 'records_number' => 0})
        end
      end
      rec_arr
    end

    def get_range interval
      if interval == 'day'
        (date_range[0]..date_range[-1]).to_a.map{|d| d.to_date}
      else
        (date_range[0].send("beginning_of_#{interval}")..date_range[-1].send("beginning_of_#{interval}"))
            .to_a
            .select{|d| d == d.send("beginning_of_#{interval}")}
      end
    end

  end
end

