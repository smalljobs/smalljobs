# Validator that ensure an email is unique over job brokers,
# job providers and job seekers.
#
# Only checks the foreign tables.
#
class UniqueEmailValidator < ActiveModel::Validator
  def validate(record)
    if record.email
      if JobBroker.where('email=? OR unconfirmed_email=?', record.email, record.email).count > 0
        record.errors.add(:email, options[:message] || :broker_email)
      end unless record.is_a?(JobBroker)

      if JobProvider.where('email=? OR unconfirmed_email=?', record.email, record.email).count > 0
        record.errors.add(:email, options[:message] || :provider_email)
      end unless record.is_a?(JobProvider)

      if JobSeeker.where('email=? OR unconfirmed_email=?', record.email, record.email).count > 0
        record.errors.add(:email, options[:message] || :seeker_email)
      end unless record.is_a?(JobSeeker)
    end
  end
end
