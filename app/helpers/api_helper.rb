module ApiHelper
  # Converts given region to json format
  #
  # @param region [Region] region to convert
  #
  # @return [Json] region in json format
  #
  def self.region_to_json(region)
    json = {}
    json[:id] = region.id
    json[:name] = region.name
    places = []
    for place in region.places
      places.append(place_to_json(place))
    end

    json[:places] = places
    return json
  end

  # Converts given place to json format
  #
  # @param place [Place] place to convert
  #
  # @return [Json] place in json format
  #
  def self.place_to_json(place)
    json = {}
    json[:id] = place.id
    json[:name] = place.name
    json[:zip] = place.zip
    json[:province] = place.province
    json[:state] = place.state
    json[:lat] = place.latitude
    json[:lng] = place.longitude
    return json
  end

  # Converts given organization to json format
  #
  # @param organization [Organization] organization to convert
  # @param ragion_id [Integer] id of a region that organization belongs to
  #
  # @return [Json] organization in json format
  #
  def self.organization_to_json(organization, region_id)
    json = {}
    json[:id] = organization.id
    json[:region_id] = region_id
    json[:name] = organization.name
    json[:description] = organization.description
    json[:street] = organization.street
    json[:phone] = organization.phone
    json[:email] = organization.email
    json[:active] = organization.active
    json[:wage_factor] = organization.wage_factor
    json[:place] = place_to_json(organization.place)
    brokers = []
    for broker in organization.brokers
      brokers.append(broker_to_json(broker))
    end
    json[:brokers] = brokers
    return json
  end

  # Converts given broker to json format
  #
  # @param broker [Broker] broker to convert
  #
  # @return [Json] broker in json format
  #
  def self.broker_to_json(broker)
    json = {}
    json[:id] = broker.id
    json[:name] = broker.name
    json[:surname] = broker.lastname
    json[:email] = broker.email
    return json
  end

  # Converts given job to json format
  #
  # @param job [Job] job to convert
  # @param organization [Organization]
  # @param show_provider [Bool]
  # @param show_organization [Bool]
  # @param show_assignments [Bool]
  # @param allocation_id [Integer]
  #
  # @return [Json] job in json format
  #
  def self.job_to_json(job, organization, show_provider, show_organization, show_assignments, allocation_id)
    json = {}
    json[:id] = job.id
    json[:organization_id] = organization.id

    status = Job::state_to_integer(job.state)

    json[:status] = status
    json[:title] = job.title
    json[:long_description] = job.long_description
    json[:short_description] = job.short_description
    json[:category] = category_to_json(job.work_category)
    json[:duration] = job.duration
    json[:salary] = job.salary
    json[:salary_type] = job.salary_type
    json[:workers] = job.manpower
    json[:date_type] = job.date_type
    json[:start_date] = job.start_date != nil ? job.start_date.strftime('%s') : nil
    json[:end_date] = job.end_date != nil ? job.end_date.strftime('%s') : nil
    if show_provider
      json[:provider] = provider_to_json(job.provider)
    end
    if show_organization
      json[:organization] = organization_to_json(organization, organization.regions.first == nil ? nil : organization.regions.first.id)
    end
    if show_assignments
      assignments = []
      for assignment in job.assignments
        assignments.append(assignment_to_json(assignment))
      end

      json[:assignments] = assignments
    end

    return json
  end

  # Converts given assignment to json format
  #
  # @param assignment [Assignment] assignment to convert
  #
  # @return [Json] assignment in json format
  #
  def self.assignment_to_json(assignment)
    json = {}
    json[:id] = assignment.id
    if assignment.active?
      json[:status] = 0
    else
      json[:status] = 1
    end
    json[:message] = assignment.feedback
    json[:job_id] = assignment.job.id
    json[:user_id] = assignment.seeker.id
    json[:provider_id] = assignment.provider.id
    json[:start_datetime] = assignment.start_time != nil ? assignment.start_time.strftime('%s') : nil
    json[:stop_datetime] = assignment.end_time != nil ? assignment.end_time.strftime('%s') : nil
    json[:duration] = assignment.duration
    json[:payment] = assignment.payment
    return json
  end

  # Converts given work category to json format
  #
  # @param category [WorkCategory] work category to convert
  #
  # @return [Json] work category in json format
  #
  def self.category_to_json(category)
    json = {}
    json[:id] = category.id
    json[:name] = category.name
    return json
  end

  # Converts given provider to json format
  #
  # @param provider [Provider] provider to convert
  #
  # @return [Json] provider in json format
  #
  def self.provider_to_json(provider)
    json = {}
    return if provider.nil?
    json[:id] = provider.id
    json[:company] = provider.company
    json[:firstname] = provider.firstname
    json[:lastname] = provider.lastname
    json[:phone] = provider.phone
    json[:street] = provider.street
    json[:place] = place_to_json(provider.place)
    return json
  end

  # Converts given allocation to json format
  #
  # @param allocation [Allocation] allocation to convert
  #
  # @return [Json] allocation in json format
  #
  def self.allocation_to_json(allocation)
    json = {}
    json[:id] = allocation.id
    json[:status] = allocation.state
    json[:message] = allocation.feedback_seeker
    json[:job_id] = allocation.job_id
    json[:user_id] = allocation.seeker_id
    json[:provider_id] = allocation.provider_id
    json[:start_datetime] = allocation.start_datetime != nil ? allocation.start_datetime.strftime('%s') : nil
    json[:stop_datetime] = allocation.stop_datetime != nil ? allocation.stop_datetime.strftime('%s') : nil
    json[:payment] = allocation.job.salary

    duration = nil
    if allocation.stop_datetime != nil && allocation.start_datetime != nil
      duration = allocation.stop_datetime - allocation.start_datetime
    end

    json[:duration] = duration
    return json
  end

  # Converts given assignment with additional data to json format
  #
  # @param assignment [Assignment] assignment to convert
  # @param show_provider [Bool]
  # @param show_organization [Bool]
  # @param show_seeker [Bool]
  # @param show_job [Bool]
  #
  # @return [Json] assignment in json format
  #
  def self.assignment_with_data_to_json(assignment, show_provider, show_organization, show_seeker, show_job)
    json = {}
    json[:id] = assignment.id
    if assignment.active?
      json[:status] = 0
    else
      json[:status] = 1
    end

    json[:message] = assignment.feedback
    json[:job_id] = assignment.job.id
    json[:user_id] = assignment.seeker.id
    json[:provider_id] = assignment.provider.id
    json[:start_datetime] = assignment.start_time != nil ? assignment.start_time.strftime('%s') : nil
    json[:stop_datetime] = assignment.end_time != nil ? assignment.end_time.strftime('%s') : nil
    json[:duration] = assignment.duration
    json[:payment] = assignment.payment

    if show_provider
      json[:provider] = provider_to_json(assignment.provider)
    end

    if show_organization
      json[:organization] = organization_to_json(assignment.provider.organization, assignment.provider.organization.regions.first.id)
    end

    if show_seeker
      json[:user] =seeker_to_json(assignment.seeker)
    end

    if show_job
      json[:job] = job_to_json(assignment.job, assignment.provider.organization, false, false, false, nil)
    end

    return json
  end

  # Converts given allocation with additional data to json format
  #
  # @param allocation [Allocation] allocation to convert
  # @param show_provider [Bool]
  # @param show_organization [Bool]
  # @param show_seeker [Bool]
  #
  # @return [Json] allocation in json format
  #
  def self.allocation_with_data_to_json(allocation, show_provider, show_organization, show_seeker)
    json = {}
    json[:id] = allocation.id
    json[:status] = allocation.state
    json[:message] = allocation.feedback_seeker
    json[:job_id] = allocation.job_id
    json[:user_id] = allocation.seeker_id
    json[:provider_id] = allocation.provider_id
    json[:start_datetime] = allocation.start_datetime
    json[:stop_datetime] = allocation.stop_datetime
    json[:payment] = allocation.job.salary

    duration = nil
    if allocation.stop_datetime != nil && allocation.start_datetime != nil
      duration = allocation.stop_datetime - allocation.start_datetime
    end

    json[:duration] = duration

    if show_provider
      json[:provider] = provider_to_json(allocation.provider)
    end

    if show_organization
      json[:organization] = organization_to_json(allocation.provider.organization, allocation.provider.organization.regions.first.id)
    end

    if show_seeker
      json[:user] =seeker_to_json(allocation.seeker)
    end

    return json
  end

  # Converts given allocation with job data to json format
  #
  # @param allocation [Allocation] allocation to convert
  # @param job [Job]
  # @param show_provider [Bool]
  # @param show_organization [Bool]
  # @param show_seeker [Bool]
  # @param show_assignments [Bool]
  #
  # @return [Json] allocation in json format
  #
  def self.allocation_with_job_to_json(allocation, job, show_provider, show_organization, show_seeker, show_assignments)
    json = {}
    json[:id] = allocation.id
    json[:job_id] = allocation.job_id
    json[:user_id] = allocation.seeker_id
    json[:status] = Allocation.states[allocation.state]

    json[:job] = job_to_json(job, allocation.seeker.organization, show_provider, show_organization, show_assignments, allocation.id)

    if show_seeker
      json[:user] = seeker_to_json(allocation.seeker)
    end

    return json
  end

  # Converts given seeker to json format
  #
  # @param seeker [Seeker] seeker to convert
  #
  # @return [Json] seeker in json format
  #
  def self.seeker_to_json(seeker)
    json = {}
    json[:id] = seeker.id
    json[:app_user_id] = seeker.app_user_id
    json[:organization_id] = seeker.organization_id
    json[:created_at] = seeker.created_at.strftime('%s')
    json[:updated_at] = seeker.updated_at.strftime('%s')
    json[:lastname] = seeker.lastname
    json[:firstname] = seeker.firstname
    json[:birthdate] = seeker.date_of_birth.strftime('%s')
    json[:phone] = seeker.phone
    json[:street] = seeker.street
    json[:status] = Seeker.statuses[seeker.status]
    json[:sex] = seeker.sex
    json[:place] = place_to_json(seeker.place)
    json[:categories] = []
    for category in seeker.work_categories
      json[:categories].append(category_to_json(category))
    end

    return json
  end

  # Generate random, six digits long, confirmation code
  #
  # @return [String] generated code
  #
  def self.generate_code
    (0...6).map { SecureRandom.random_number(10) }.join
  end

  # Return place id for given zip code
  #
  # @param zip [String] zip code
  #
  # @return [Int] id of a place with given zip code, or nil if no such place exists in database
  def self.zip_to_place_id(zip)
    place = Place.find_by(zip: zip)
    if place.nil?
      return nil
    else
      return place.id
    end
  end
end