class JobsCertificate < ApplicationRecord
  before_create :generate_jobs_certificate_id
  belongs_to :seeker


  private
  def generate_jobs_certificate_id
    self.jobs_certyficate_id = SecureRandom.uuid if self.jobs_certyficate_id.nil?
  end
end
