require 'spec_helper'

describe 'layouts/application.html.haml' do
  context 'on the main site' do
    before do
      controller.request.stub(subdomain: 'www')
    end

    context 'navigation' do
      it 'renders the link to the about us page' do
        render
        expect(rendered).to match(about_us_path)
      end

      it 'renders the link to features page' do
        render
        expect(rendered).to match(features_path)
      end

      it 'renders the link to join us page' do
        render
        expect(rendered).to match(join_us_path)
      end
    end

    context 'footer navigation' do
      it 'renders the link to the rules of action page' do
        render
        expect(rendered).to match(rules_of_action_path)
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

  context 'on the region site' do
    before do
      controller.request.stub(subdomain: 'bremgarten')
    end

    context 'navigation' do
      context 'for a broker' do
        auth_broker(:broker) { Fabricate(:broker) }

        it 'renders the link to the broker dashboard' do
          render
          expect(rendered).to match(broker_dashboard_path)
        end

        it 'renders the link to sign out' do
          render
          expect(rendered).to match(destroy_broker_session_path)
        end
      end

      context 'for a provider' do
        auth_provider(:provider) { Fabricate(:provider) }

        it 'renders the link to the provider dashboard' do
          render
          expect(rendered).to match(provider_dashboard_path)
        end

        it 'renders the link to sign out' do
          render
          expect(rendered).to match(destroy_provider_session_path)
        end
      end

      context 'for a seeker' do
        auth_seeker(:seeker) { Fabricate(:seeker) }

        it 'renders the link to the seeker dashboard' do
          render
          expect(rendered).to match(seeker_dashboard_path)
        end

        it 'renders the link to sign out' do
          render
          expect(rendered).to match(destroy_seeker_session_path)
        end
      end
    end

    context 'footer navigation' do
      it 'renders the link to the about us page' do
        render
        expect(rendered).to match(about_us_path)
      end

      it 'renders the link to the rules of action page' do
        render
        expect(rendered).to match(rules_of_action_path)
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

  context 'flash messages' do
    it 'renders a flash notice' do
      flash[:notice] = 'Hallo Notiz'
      render
      expect(rendered).to match('Hallo Notiz')
    end

    it 'renders a flash error' do
      flash[:error] = 'Hallo Error'
      render
      expect(rendered).to match('Hallo Error')
    end

    it 'renders a flash alert' do
      flash[:alert] = 'Hallo Alert'
      render
      expect(rendered).to match('Hallo Alert')
    end
  end
end
