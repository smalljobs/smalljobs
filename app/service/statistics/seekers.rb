module Statistic
  class Seekers

    attr_accessor :organization, :interval

    def initialize(organization)
      organization = organization
      interval = interval
    end

    def call
    end

    def get_data_by_interval

    end

    def get_grouped_data
      @seekers = current_broker.seekers.where.not(status: 3).where(organization_id: organization).where(created_at: date_range).includes(:place, :organization).group('seekers.id').order(:updated_at).length

      @seekers = current_broker.seekers.where.not(status: 3).where(organization_id: organization).includes(:place, :organization).group('seekers.id').order(:created_at).group_by{|x|x.created_at.day}.each do |x,y|
        p "#{x} #{y.count} #{y.first.created_at} #{y.last.created_at}"
      end

      sql = "
        SELECT date_trunc('#{interval}', created_at) AS \"date_interval\" , count(*) AS \"records_number\"
        FROM seekers
        GROUP BY 1
        ORDER BY 1;
      "
      records_array = ActiveRecord::Base.connection.execute(sql)
      Statistic::Dataset.new(records_array).call
    end

  end
end