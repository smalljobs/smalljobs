module Statistic
  class Seekers

    attr_accessor :organization

    def initialize(organization)
      organization = organization
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

      # Seeker.where(:published_state => 'published').group('year(created_at)').group('month(created_at)').count(:id)
      # @seekers = current_broker
      #
      # organizations_id = "(#{Organization.all.pluck(:id).uniq.join(',')})"
      # Seeker.find_by_sql("
      #   SELECT *
      #   FROM seekers
      #   WHERE organization_id IN #{organizations_id}
      # ")
      Seeker.find_by_sql("
        SELECT COUNT(id),to_char(to_date('2014-01-10 13:30:10','yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd') AS date_part
        FROM seekers
        GROUP BY to_char(to_date('2014-01-10 13:30:10','yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd')
      ")
    end

  end
end