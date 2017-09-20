class ChangeJobStates < ActiveRecord::Migration[5.0]
  class Job < ActiveRecord::Base
  end

  def change
    Job.where(state: 'feedback').each do |job|
      job.update_attributes!(state: 'finished')
    end

    Job.where(state: 'running').each do |job|
      job.update_attributes!(state: 'check')
    end
  end
end
