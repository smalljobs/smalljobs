require 'spec_helper'

describe 'layouts/application.html.haml' do
  context 'navigation' do
    context 'for the anonymous user' do
      it 'renders the link to the sign in page' do
        render
        #expect(rendered).to match(root_path)
      end
    end

    context 'for a broker' do
      auth_broker(:broker) { Fabricate(:job_broker) }

      it 'renders the link to the broker dashboard' do
        render
        expect(rendered).to match(job_brokers_dashboard_path)
      end

      it 'renders the link to sign out' do
        render
        expect(rendered).to match(destroy_job_broker_session_path)
      end
    end

    context 'for a provider' do
      auth_provider(:provider) { Fabricate(:job_provider) }

      it 'renders the link to the provider dashboard' do
        render
        expect(rendered).to match(job_providers_dashboard_path)
      end

      it 'renders the link to sign out' do
        render
        expect(rendered).to match(destroy_job_provider_session_path)
      end
    end

    context 'for a seeker' do
      auth_seeker(:seeker) { Fabricate(:job_seeker) }

      it 'renders the link to the seeker dashboard' do
        render
        expect(rendered).to match(job_seekers_dashboard_path)
      end

      it 'renders the link to sign out' do
        render
        expect(rendered).to match(destroy_job_seeker_session_path)
      end
    end
  end

  context 'footer navigation' do
    it 'renders the link to the about us page' do
      render
      expect(rendered).to match(about_us_path)
    end

    it 'renders the link to the privacy policy page' do
      render
      expect(rendered).to match(privacy_policy_path)
    end

    it 'renders the link to the terms of service page' do
      render
      expect(rendered).to match(terms_of_service_path)
    end
  end
end
