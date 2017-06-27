class Todo < ApplicationRecord
  enum record_type: { job: 1, provider: 2, allocation: 3, seeker: 4 }

  belongs_to :todotype
  belongs_to :seeker
  belongs_to :provider
  belongs_to :job
  belongs_to :allocation

  def organization_id
    if record_type == 'job'
      job.try(:organization).try(:id)
    elsif record_type == 'provider'
      provider.try(:organization).try(:id)
    elsif record_type == 'allocation'
      allocation.job.try(:organization).try(:id)
    elsif record_type == 'seeker'
      seeker.try(:organization).try(:id)
    end
  end

  def link_to_context
    if record_type == 'job'
      url_for edit_broker_job_path(job_id)
    elsif record_type == 'provider'
      url_for edit_broker_provider_path(provider_id)
    elsif record_type == 'allocation'
      url_for broker_job_allocation_path(job_id, seeker_id)
    elsif record_type == 'seeker'
      url_for edit_broker_seeker_path(seeker_id)
    end
  end

  def text_for_type
    if record_type == 'job'
      'Job'
    elsif record_type == 'provider'
      'Anbieterln'
    elsif record_type == 'allocation'
      ''
    elsif record_type == 'seeker'
      'Jugendlicher'
    end
  end
end
