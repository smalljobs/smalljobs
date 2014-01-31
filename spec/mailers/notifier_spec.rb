require 'spec_helper'

describe 'Notifier' do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:region) { Fabricate(:region_bremgarten) }
  let(:place) { region.places.first }
  let(:org) { Fabricate(:organization, place: place) }

  let(:seeker_1) { Fabricate(:seeker, place: place) }
  let(:seeker_2) { Fabricate(:seeker, place: place) }

  let(:provider_1) { Fabricate(:provider, place: place) }
  let(:provider_2) { Fabricate(:provider, place: place) }

  let(:broker_1) { Fabricate(:broker) }
  let(:broker_2) { Fabricate(:broker) }

  let(:broker_mails) { [broker_1.email, broker_2.email] }
  let(:seeker_mails) { [seeker_1.email, seeker_2.email] }

  let(:job) { Fabricate(:job, provider: provider_1, seekers: [seeker_1, seeker_2]) }

  before do
    Fabricate(:employment, organization: org, region: region, broker: broker_1)
    Fabricate(:employment, organization: org, region: region, broker: broker_2)
  end

  describe '#send_agreement_for_seeker' do
    let(:mail) { Notifier.send_agreement_for_seeker(seeker_1) }

    it 'sends the mail to the seekers email' do
      mail.should deliver_to(seeker_1.email)
    end

    it 'sends a copy to the seeker brokers' do
      mail.should cc_to(broker_mails)
    end

    it 'contains the seekers name' do
      mail.should have_body_text(seeker_1.name)
    end

    it 'contains the organization name' do
      mail.should have_body_text(org.name)
    end

    it 'contains the organization street' do
      mail.should have_body_text(org.street)
    end

    it 'contains the organization place' do
      mail.should have_body_text(org.place.zip)
      mail.should have_body_text(org.place.name)
    end

    it 'contains the organization website' do
      mail.should have_body_text(org.website)
    end

    it 'contains the organization phone' do
      mail.should have_body_text(org.phone)
    end

    it 'contains the organization email' do
      mail.should have_body_text(org.email)
    end

    it 'contains the broker names' do
      mail.should have_body_text(broker_1.name)
      mail.should have_body_text(broker_2.name)
    end

    it 'contains the broker phones' do
      mail.should have_body_text(broker_1.phone.phony_formatted)
      mail.should have_body_text(broker_2.phone.phony_formatted)
    end

    it 'contains the broker mobiles' do
      mail.should have_body_text(broker_1.mobile.phony_formatted)
      mail.should have_body_text(broker_2.mobile.phony_formatted)
    end

    it 'contains the broker emails' do
      mail.should have_body_text(broker_1.email)
      mail.should have_body_text(broker_2.email)
    end
  end

  describe '#new_seeker_signup_for_broker' do
    let(:mail) { Notifier.new_seeker_signup_for_broker(seeker_1) }

    it 'sends the mail to the brokers email' do
      mail.should deliver_to(broker_mails)
    end

    it 'greets the brokers by first name' do
      mail.should have_body_text(broker_1.firstname)
      mail.should have_body_text(broker_2.firstname)
    end

    it 'contains the link to the brokers seeker view' do
      mail.should have_body_text(broker_seeker_url(seeker_1, subdomain: 'bremgarten'))
    end
  end

  describe '#new_provider_signup_for_broker' do
    let(:mail) { Notifier.new_provider_signup_for_broker(provider_1) }

    it 'sends the mail to the brokers email' do
      mail.should deliver_to(broker_mails)
    end

    it 'greets the brokers by first name' do
      mail.should have_body_text(broker_1.firstname)
      mail.should have_body_text(broker_2.firstname)
    end

    it 'contains the link to the brokers provider view' do
      mail.should have_body_text(broker_provider_url(provider_1, subdomain: 'bremgarten'))
    end
  end

  describe '#job_created_for_broker' do
    let(:mail) { Notifier.job_created_for_broker(job) }

    it 'sends the mail to the brokers email' do
      mail.should deliver_to(broker_mails)
    end

    it 'greets the brokers by first name' do
      mail.should have_body_text(broker_1.firstname)
      mail.should have_body_text(broker_2.firstname)
    end

    it 'contains the job title' do
      mail.should have_body_text(job.title)
    end

    it 'contains the job description' do
      mail.should have_body_text(job.description)
    end

    it 'contains the link to the brokers job view' do
      mail.should have_body_text(broker_job_url(job, subdomain: 'bremgarten'))
    end
  end

  describe '#provider_activated_for_provider' do
    let(:mail) { Notifier.provider_activated_for_provider(provider_1) }

    context 'with a provider that has an email' do
      it 'sends the mail to the brokers email' do
        mail.should deliver_to(provider_1.email)
      end
    end

    context 'with a provider that does not have an email' do
      let(:provider_1) { Fabricate(:provider, email: nil, place: place) }

      it 'sends the mail to the brokers email' do
        mail.should deliver_to(broker_mails)
      end

      it 'contains the link to more provider info' do
        mail.should have_body_text(broker_provider_url(provider_1, subdomain: 'bremgarten'))
      end
    end

    it 'greets the provider name' do
      mail.should have_body_text(provider_1.name)
    end

    it 'contains the organization name' do
      mail.should have_body_text(org.name)
    end

    it 'contains the organization street' do
      mail.should have_body_text(org.street)
    end

    it 'contains the organization place' do
      mail.should have_body_text(org.place.zip)
      mail.should have_body_text(org.place.name)
    end

    it 'contains the organization website' do
      mail.should have_body_text(org.website)
    end

    it 'contains the organization phone' do
      mail.should have_body_text(org.phone)
    end

    it 'contains the organization email' do
      mail.should have_body_text(org.email)
    end

    it 'contains the broker names' do
      mail.should have_body_text(broker_1.name)
      mail.should have_body_text(broker_2.name)
    end

    it 'contains the broker phones' do
      mail.should have_body_text(broker_1.phone.phony_formatted)
      mail.should have_body_text(broker_2.phone.phony_formatted)
    end

    it 'contains the broker mobiles' do
      mail.should have_body_text(broker_1.mobile.phony_formatted)
      mail.should have_body_text(broker_2.mobile.phony_formatted)
    end

    it 'contains the broker emails' do
      mail.should have_body_text(broker_1.email)
      mail.should have_body_text(broker_2.email)
    end
  end

  describe '#job_connected_for_seekers' do
    let(:mail) { Notifier.job_connected_for_seekers(job) }

    it 'sends the mail to the brokers email' do
      mail.should deliver_to(seeker_mails)
    end

    it 'greets the seekers by first name' do
      mail.should have_body_text(seeker_1.firstname)
      mail.should have_body_text(seeker_2.firstname)
    end

    it 'contains the job title' do
      mail.should have_body_text(job.title)
    end

    it 'contains the job description' do
      mail.should have_body_text(job.description)
    end

    it 'contains the provider name' do
      mail.should have_body_text(provider_1.name)
    end

    it 'contains the provider street' do
      mail.should have_body_text(provider_1.street)
    end

    it 'contains the provider place' do
      mail.should have_body_text(provider_1.place.zip)
      mail.should have_body_text(provider_1.place.name)
    end

    it 'contains the provider phone' do
      mail.should have_body_text(provider_1.phone.phony_formatted)
    end

    it 'contains the provider mobile' do
      mail.should have_body_text(provider_1.mobile.phony_formatted)
    end

    it 'contains the provider email' do
      mail.should have_body_text(provider_1.email)
    end

    it 'contains the link to the job view' do
      mail.should have_body_text(job_url(job, subdomain: 'bremgarten'))
    end
  end

  describe '#job_connected_for_provider' do
    let(:mail) { Notifier.job_connected_for_provider(job) }

    it 'sends the mail to the provider email' do
      mail.should deliver_to(provider_1)
    end

    context 'with a provider that does not have an email' do
      let(:provider_1) { Fabricate(:provider, email: nil, place: place) }

      it 'sends the mail to the brokers email' do
        mail.should deliver_to(broker_mails)
      end

      it 'contains the link to more provider info' do
        mail.should have_body_text(broker_provider_url(provider_1, subdomain: 'bremgarten'))
      end
    end

    it 'greets the provider by name' do
      mail.should have_body_text(provider_1.firstname)
    end

    it 'contains the job title' do
      mail.should have_body_text(job.title)
    end

    it 'contains the job description' do
      mail.should have_body_text(job.description)
    end

    it 'contains the names of the seekers' do
      mail.should have_body_text(seeker_1.name)
      mail.should have_body_text(seeker_2.name)
    end

    it 'contains the streets of the seekers' do
      mail.should have_body_text(seeker_1.street)
      mail.should have_body_text(seeker_2.street)
    end

    it 'contains the places of the seekers' do
      mail.should have_body_text(seeker_1.place.zip)
      mail.should have_body_text(seeker_2.place.name)
      mail.should have_body_text(seeker_1.place.zip)
      mail.should have_body_text(seeker_2.place.name)
    end

    it 'contains the emails of the seekers' do
      mail.should have_body_text(seeker_1.email)
      mail.should have_body_text(seeker_2.email)
    end

    it 'contains the phones of the seekers' do
      mail.should have_body_text(seeker_1.phone.phony_formatted)
      mail.should have_body_text(seeker_2.phone.phony_formatted)
    end

    it 'contains the mobiles of the seekers' do
      mail.should have_body_text(seeker_1.mobile.phony_formatted)
      mail.should have_body_text(seeker_2.mobile.phony_formatted)
    end

    it 'contains the link to the provider job view' do
      mail.should have_body_text(provider_job_url(job, subdomain: 'bremgarten'))
    end
  end

  describe '#job_rating_reminder_for_seekers' do
    let(:mail) { Notifier.job_rating_reminder_for_seekers(job) }

    it 'sends the mail to the brokers email' do
      mail.should deliver_to(seeker_mails)
    end

    it 'greets the seekers by first name' do
      mail.should have_body_text(seeker_1.firstname)
      mail.should have_body_text(seeker_2.firstname)
    end

    it 'contains the job title' do
      mail.should have_body_text(job.title)
    end

    it 'contains the link to the job view' do
      mail.should have_body_text(job_url(job, subdomain: 'bremgarten'))
    end
  end

  describe '#job_rating_reminder_for_provider' do
    let(:mail) { Notifier.job_rating_reminder_for_provider(job) }

    it 'sends the mail to the provider email' do
      mail.should deliver_to(provider_1)
    end

    context 'with a provider that does not have an email' do
      let(:provider_1) { Fabricate(:provider, email: nil, place: place) }

      it 'sends the mail to the brokers email' do
        mail.should deliver_to(broker_mails)
      end

      it 'contains the link to more provider info' do
        mail.should have_body_text(broker_provider_url(provider_1, subdomain: 'bremgarten'))
      end
    end

    it 'greets the provider by name' do
      mail.should have_body_text(provider_1.firstname)
    end

    it 'contains the job title' do
      mail.should have_body_text(job.title)
    end

    it 'contains the link to the provider job view' do
      mail.should have_body_text(provider_job_url(job, subdomain: 'bremgarten'))
    end
  end
end
