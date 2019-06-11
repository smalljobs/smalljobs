module Statistics
  class GetJobsIds

    attr_accessor :organization, :options, :date_range

    def initialize(date_range, organization, options)
      @organization = organization
      @date_range = date_range
      @options = options
    end

    def is_true?(option)
      option == 'true'
    end

    def is_false?(option)
      !is_true?(option)
    end

    def region
      Region.find_by(id: options[:region_id])
    end

    def call
      get_jobs_ids
    end

    def get_jobs_ids
      if is_true?(options[:active]) && is_true?(options[:archived])
        region.jobs
              .where(created_at: (date_range[0]..date_range[-1]), organization_id: organization)
              .pluck(:id).uniq
      elsif is_true?(options[:active]) && is_false?(options[:archived])
        region.jobs
            .where(created_at: (date_range[0]..date_range[-1]), organization_id: organization)
            .where.not(state: 'finished')
            .pluck(:id).uniq
      elsif is_false?(options[:active]) && is_true?(options[:archived])
        region.jobs
            .where(created_at: (date_range[0]..date_range[-1]), organization_id: organization)
            .where(state: 'finished')
            .pluck(:id).uniq
      elsif is_false?(options[:active]) && is_false?(options[:archived])
        []
      end
    end
  end
end