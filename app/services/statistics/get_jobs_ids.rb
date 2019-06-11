module Statistics
  class GetJobsIds

    attr_accessor :organization, :options, :date_range

    def initialize(date_range, organization, options)
      @organization = organization
      @date_range = date_range
      @options = options
    end

    def region
      Region.find_by(id: options[:region_id])
    end

    def call
      get_jobs_ids
    end

    def get_jobs_ids
      region.jobs.where(created_at: (date_range[0]..date_range[-1]), organization_id: organization).pluck(:id).uniq
    end
  end
end