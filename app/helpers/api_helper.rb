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
    json[:id] = place&.id
    json[:name] = place&.name
    json[:zip] = place&.zip
    json[:province] = place&.province
    json[:state] = place&.state
    json[:lat] = place&.latitude
    json[:lng] = place&.longitude
    return json
  end

  # Converts given organization to json format
  #
  # @param organization [Organization] organization to convert
  # @param ragion_id [Integer] id of a region that organization belongs to
  #
  # @return [Json] organization in json format
  #
  def self.organization_to_json(organization, region_id, message=nil, agreement_url=nil)
    require 'redcloth'
    json = {}
    json[:id] = organization.id
    json[:region_id] = region_id
    json[:name] = organization.name
    json[:description] = organization.description
    json[:street] = organization.street
    json[:phone] = organization.phone
    json[:email] = organization.email
    json[:active] = organization.active
    json[:default_broker_id] = organization.default_broker_id
    json[:signature_on_contract] = organization.signature_on_contract
    json[:wage_factor] = organization.wage_factor
    json[:salary_deduction] = organization.salary_deduction
    json[:hide_salary] = organization.hide_salary
    json[:place] = place_to_json(organization.place)
    json[:opening_hours] = RedCloth.new(organization.opening_hours || "").to_html
    json[:registration_welcome_message] = message
    json[:agreement_url] = agreement_url
    json[:vacations] = {
        active: organization.vacation_active,
        start: organization.start_vacation_date,
        end: organization.end_vacation_date,
        title: organization.vacation_title,
        text: organization.vacation_text
    }
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
    json[:user_type] = "broker"
    json[:id] = broker.id
    json[:firstname] = broker.firstname
    json[:surname] = broker.lastname
    json[:email] = broker.email
    json[:rc_id] = broker.rc_id
    json[:rc_username] = broker.rc_username
    json[:mobile] = broker.mobile
    json[:phone] = broker.phone
    json[:updated_at] = broker.updated_at
    json[:app_user_id] = broker.app_user_id

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
  def self.job_to_json(job, organization, show_provider, show_organization, show_assignments, allocation_id, seeker=nil)
    json = job_to_json_v1({job: job,
                           organization: organization,
                           show_provider: show_provider,
                           show_organization: show_organization,
                           show_assignments: show_assignments,
                           allocation_id: allocation_id,
                           seeker: seeker})

    return json
  end

  def self.job_to_json_v1(hash = {})
    job = hash[:job]
    organization = hash[:organization]
    show_provider = hash[:show_provider]
    show_organization = hash[:show_organization]
    show_assignments = hash[:show_assignments]
    allocation_id = hash[:allocation_id]
    seeker = hash[:seeker]
    show_allocations = hash[:show_allocations]

    json = {}
    json[:id] = job.id
    json[:organization_id] = organization&.id

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
    if show_organization and organization.present?
      json[:organization] = organization_to_json(organization, organization.regions.first == nil ? nil : organization.regions.first.id)
    end
    if show_assignments and seeker.present?
      assignments = []
      all_assignments = job.assignments
      all_assignments = all_assignments.where(seeker_id: seeker.id) if seeker.present?
      all_assignments.each do |assignment|
        assignments.append(assignment_to_json(assignment))
      end

      json[:assignments] = assignments
    end


    if show_allocations and seeker.present?
      allocations = []
      all_allocations = job.allocations
      all_allocations = all_allocations.where(seeker_id: seeker.id) if seeker.present?
      all_allocations.each do |allocation|
        allocations.append(allocation_to_json(allocation))
      end
      json[:allocations] = allocations
    end
    salary_to_show = nil

    if seeker.present? and organization.present? and seeker.class == Seeker
      if (job.salary_type == "hourly_per_age")
        salary_to_show = I18n.t("helpers.api_helpers.salary_calculated_1", salary: (seeker.age * organization.wage_factor - organization.salary_deduction), duration: job.duration)
      elsif (job.salary_type == "hourly" )
        salary_to_show = I18n.t("helpers.api_helpers.salary_calculated_1", salary: job.salary, duration: job.duration)
      elsif (job.salary_type == "fixed")
        salary_to_show = I18n.t("helpers.api_helpers.salary_calculated_2", salary: job.salary)
      end
    end


    json[:salary_calculated] = salary_to_show

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
    json[:icon_name] = category.icon_name
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
    json[:mobile] = provider.mobile
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
    json[:status] = allocation.state_before_type_cast
    json[:message] = allocation.feedback_seeker
    json[:job_id] = allocation.job_id
    json[:user_id] = allocation.seeker_id
    json[:provider_id] = allocation.provider_id
    json[:payment] = allocation.job.salary
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
    json[:provider_id] = assignment.provider_id
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
  def self.allocation_with_job_to_json(allocation, job, show_provider, show_organization, show_seeker, show_assignments, current_seeker=nil)
    json = {}
    json[:id] = allocation.id
    json[:job_id] = allocation.job_id
    json[:user_id] = allocation.seeker_id
    json[:status] = Allocation.states[allocation.state]

    json[:job] = job_to_json(job, job.organization, show_provider, show_organization, show_assignments, allocation.id, current_seeker)

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
    json[:user_type] = "seeker"
    json[:id] = seeker.id
    json[:app_user_id] = seeker.app_user_id
    json[:created_at] = seeker.created_at.strftime('%s')
    json[:updated_at] = seeker.updated_at.strftime('%s')
    json[:lastname] = seeker.lastname
    json[:firstname] = seeker.firstname
    json[:birthdate] = seeker.date_of_birth.strftime('%s')
    json[:phone] = seeker.phone
    json[:street] = seeker.street
    json[:status] = Seeker.statuses[seeker.status]
    json[:sex] = seeker.sex
    json[:place_id] = seeker.place_id
    json[:place] = place_to_json(seeker.place)
    json[:login] = seeker.login
    json[:mobile] = seeker.mobile
    json[:email] = seeker.email
    json[:parent_email] = seeker.parent_email
    json[:additional_contacts] = seeker.additional_contacts
    json[:languages] = seeker.languages
    json[:occupation] = seeker.occupation
    json[:occupation_end_date] = seeker.occupation_end_date
    json[:contact_availability] = seeker.contact_availability
    json[:contact_preference] = seeker.contact_preference
    # json[:organization_id] = seeker.organization_id
    json[:internal_interview] = seeker.discussion
    json[:parental_consent] = seeker.parental
    json[:organization_id] = seeker.organization_id
    json[:rc_id] = seeker.rc_id
    json[:rc_username] = seeker.rc_username
    if seeker.organization.present?

      helpers_url = Rails.application.routes.url_helpers
      host = "#{seeker.organization.regions.first.subdomain}.smalljobs.ch"
      seeker_agreement_link = helpers_url.agreement_broker_seeker_url(seeker.agreement_id, subdomain: seeker.organization.regions.first.subdomain, host: host, protocol: 'https')
      registration_welcome_message = Mustache.render(seeker.organization.welcome_app_register_msg || '', seeker_first_name: seeker.firstname, seeker_last_name: seeker.lastname, seeker_link_to_agreement: "<a file type='application/pdf' title='Elterneinverständnis herunterladen' href='#{seeker_agreement_link}'>#{seeker_agreement_link}</a>", broker_first_name: seeker.organization.brokers.first.firstname, broker_last_name: seeker.organization.brokers.first.lastname, organization_name: seeker.organization.name, organization_street: seeker.organization.street, organization_zip: seeker.organization.place.zip, organization_place: seeker.organization.place.name, organization_phone: seeker.organization.phone, organization_email: seeker.organization.email, link_to_jobboard_list: helpers_url.root_url(subdomain: seeker.organization.regions.first.subdomain, host: host, protocol: 'https'))
      registration_welcome_message.gsub! "\r\n", "<br>"
      registration_welcome_message.gsub! "\n", "<br>"

      json[:organization] = self.organization_to_json(seeker.organization, seeker.organization.regions.first.try(:id), registration_welcome_message, seeker_agreement_link)
    end
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
