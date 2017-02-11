class Seeker::DashboardsController < ApplicationController

  before_filter :authenticate_seeker!

  def show
    @my_jobs = current_seeker.jobs.to_a
    for job in @my_jobs
      allocation = Allocation.where(job_id: job.id, seeker_id: current_seeker.id).first
      if !(allocation.active? || allocation.finished?)
        @my_jobs -= [job]
      end
    end

    @jobs = current_region.jobs.to_a
    for job in @jobs
      allocation = Allocation.where(job_id: job.id, seeker_id: current_seeker.id).first
      if allocation != nil && (allocation.active? || allocation.finished?)
        @jobs -= [job]
      end
    end
  end

  protected

  def current_user
    current_seeker
  end

end
