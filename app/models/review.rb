class Review < ActiveRecord::Base
  belongs_to :job
  belongs_to :seeker
  belongs_to :provider

  validates :job, presence: true

  validates :rating, presence: true, inclusion: { in: 0..5 }

  validates :seeker, uniqueness: { scope: :job_id }, if: Proc.new { |p| p.job && p.seeker }
  validates :provider, uniqueness: { scope: :job_id }, if: Proc.new { |p| p.job && p.provider }

  validate :ensure_seeker_or_provider

  def name
    "#{ seeker.try(:name) || provider.try(:name) } #{ job.try(:title) }"
  end

  private

  def ensure_seeker_or_provider
    if self.seeker.present? && self.provider.present?
      errors.add(:seeker, I18n.t('activerecord.errors.messages.cannot_have_seeker_and_provider'))
      errors.add(:provider, I18n.t('activerecord.errors.messages.cannot_have_seeker_and_provider'))
    end

    if !self.seeker.present? && !self.provider.present?
      errors.add(:seeker, I18n.t('activerecord.errors.messages.must_have_seeker_or_provider'))
      errors.add(:provider, I18n.t('activerecord.errors.messages.must_have_seeker_or_provider'))
    end
  end
end
