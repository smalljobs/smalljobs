# The notifier is the central mailer that handles all
# email sending for the SmallJobs platform.
#
class Notifier < ActionMailer::Base
  default from: 'SmallJobs <hello@smalljobs.ch>'
  helper :mailer

  def weekly_update_for_broker(broker)
    @broker = broker
    @jobs = @broker.jobs.includes(:provider, :organization).group('jobs.id').order(:last_change_of_state).reverse_order()
    allocations = Allocation.where(job: @jobs).includes(:seeker)
    @providers = @broker.providers.includes(:place, :jobs, :organization).group('providers.id').order(:updated_at).reverse_order()
    @seekers = @broker.seekers.includes(:place, :organization).group('seekers.id').order(:updated_at).reverse_order()
    @assignments = @broker.assignments.includes(:seeker, :provider).group('assignments.id').order(:created_at).reverse_order()
    @todos = Todo.where(seeker: @seekers).or(Todo.where(provider: @providers)).or(Todo.where(job: @jobs)).or(Todo.where(allocation: allocations)).group('todos.id').order(:created_at).reverse_order()
    mail(to: broker.email, subject: "Smalljobs Todo für #{broker.organizations.first.name}") do |format|
      format.text
      format.html
    end
  end

  # Send a PDF agreement to a job seeker,
  # so he can sign and return the document,
  # so we can activate the seeker.
  #
  # @param [Seeker] the new job seeker
  #
  def send_agreement_for_seeker(seeker)
    @organization = organization_for(seeker)
    @brokers = brokers_for(seeker)
    @seeker = seeker

    attachments['agreement.pdf'] = File.read(File.expand_path(File.join(Rails.root, 'docs', 'agreement.pdf')))

    mail(to: seeker.email, cc: broker_emails_for(seeker), subject: t('mail.send_agreement_for_seeker')) do |format|
      format.text
      format.html
    end
  end

  # Notify the region brokers about
  # a new seeker sign up.
  #
  # @param [Seeker] the new job seeker
  #
  def new_seeker_signup_for_broker(seeker)
    @brokers = brokers_for(seeker)
    @seeker = seeker

    mail(to: broker_emails_for(seeker), subject: t('mail.new_seeker_signup_for_broker')) do |format|
      format.text
      format.html
    end
  end

  # Notify the region brokers about
  # a new provider sign up.
  #
  # @param [Provider] the new job provider
  #
  def new_provider_signup_for_broker(provider)
    @brokers = brokers_for(provider)
    @provider = provider

    mail(to: broker_emails_for(provider), subject: t('mail.new_provider_signup_for_broker')) do |format|
      format.text
      format.html
    end
  end

  # Notify a provider that he has been
  # activated.
  #
  # @param [Provider] the activated provider
  #
  def provider_activated_for_provider(provider)
    @organization = organization_for(provider)
    @brokers = brokers_for(provider)
    @provider = provider

    mail(to: provider_or_broker_emails_for(provider), subject: t('mail.provider_activated_for_provider')) do |format|
      format.text
      format.html
    end
  end

  # Notify a broker that a new job has
  # been created by a provider.
  #
  # @param [Job] the created job
  #
  def job_created_for_broker(job)
    @brokers = brokers_for(job.provider)
    @job = job

    mail(to: broker_emails_for(job.provider), subject: t('mail.job_created_for_broker')) do |format|
      format.text
      format.html
    end
  end

  # Notifies the job seekers that they
  # have been connected to a job.
  #
  # @param [Job] the created job
  #
  def job_connected_for_seekers(job)
    @job = job
    @provider = job.provider
    @seekers = job.seekers

    mail(to: seeker_emails_for(job), subject: t('mail.job_created_for_seekers')) do |format|
      format.text
      format.html
    end
  end

  # Notifies the job provider that
  # seekers have been connected to a job.
  #
  # @param [Job] the created job
  #
  def job_connected_for_provider(job)
    @job = job
    @provider = job.provider
    @seekers = job.seekers

    mail(to: provider_or_broker_emails_for(job.provider), subject: t('mail.job_connected_for_provider')) do |format|
      format.text
      format.html
    end
  end

  # Remind a provider to rate his job after
  # finished.
  #
  # @param [Job] the created job
  #
  def job_rating_reminder_for_provider(job)
    @job = job
    @provider = job.provider
    @seekers = job.seekers

    mail(to: provider_or_broker_emails_for(job.provider), subject: t('mail.job_rating_reminder_for_provider')) do |format|
      format.text
      format.html
    end
  end

  # Remind a seeker to rate his job after
  # finished.
  #
  # @param [Job] the created job
  #
  def job_rating_reminder_for_seekers(job)
    @job = job
    @provider = job.provider
    @seekers = job.seekers

    mail(to: seeker_emails_for(job), subject: t('mail.job_rating_reminder_for_seeker')) do |format|
      format.text
      format.html
    end
  end

  protected

  # Gets the organization of the given user
  #
  # @param [Seeker, Provider] user the user
  # @return [Organization] the organization
  #
  def organization_for(user)
    user.organization
  end

  # Get the brokers for the given user.
  #
  # @param [Seeker, Provider] user the user
  # @return [Array<Broker>] the brokers
  #
  def brokers_for(user)
    user.place.region.brokers
  end

  # Get the broker emails for the given user.
  #
  # @param [Seeker, Provider] user the user
  # @return [Array<String>] the broker emails
  #
  def broker_emails_for(user)
    brokers_for(user).pluck(:email)
  end

  # Returns the emails for the job seekers
  #
  # @param [Job] the job
  # @return [Array<String>] the emails
  #
  def seeker_emails_for(job)
    job.seekers.pluck(:email)
  end

  # Get the email of the provider or if the
  # provider does not have an email, return
  # his broker emails.
  #
  # In case the broker emails are returned,
  # the instance variable `on_behalf_of` is true.
  #
  # @param [Provider] provider the provider
  # @return [String, Array<String>] the provider or its broker emails
  #
  def provider_or_broker_emails_for(provider)
    if provider.email
      @on_behalf_of = false
      provider.email
    else
      @on_behalf_of = true
      broker_emails_for(provider)
    end
  end

end
