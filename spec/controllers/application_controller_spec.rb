require 'spec_helper'

describe ApplicationController do
  describe '#current_user' do
    context 'with a logged in admin' do
      auth_admin(:admin) { Fabricate(:admin) }

      it 'returns the admin' do
        expect(controller.current_user).to eq(admin)
      end
    end

    context 'with a logged in broker' do
      auth_broker(:broker) { Fabricate(:job_broker) }

      it 'returns the broker' do
        expect(controller.current_user).to eq(broker)
      end
    end

    context 'with a logged in provider' do
      auth_provider(:provider) { Fabricate(:job_provider) }

      it 'returns the provider' do
        expect(controller.current_user).to eq(provider)
      end
    end

    context 'with a logged in seeker' do
      auth_seeker(:seeker) { Fabricate(:job_seeker) }

      it 'returns the seeker' do
        expect(controller.current_user).to eq(seeker)
      end
    end
  end

  describe '#after_inactive_sign_up_path_for' do
    [:job_seeker, :job_provider, :job_broker].each do |type|
      context "for a #{ type}" do
        it 'returns the awaiting confirmation path when unconfirmed' do
          user = Fabricate(type, confirmed: false, active: false)
          expect(controller.after_inactive_sign_up_path_for(user)).to eq('/awaiting_confirmation')
        end

        it 'returns the awaiting activation path when inactive' do
          user = Fabricate(type, confirmed: true, active: false)
          expect(controller.after_inactive_sign_up_path_for(user)).to eq('/awaiting_activation')
        end
      end
    end
  end

  describe '#after_sign_in_path_for' do
    it 'returns the path to the broker dashboard for a broker' do
      user = Fabricate(:job_broker)
      expect(controller.after_sign_in_path_for(user)).to eq('/job_brokers/dashboard')
    end

    it 'returns the path to the provider dashboard for a provider' do
      user = Fabricate(:job_provider)
      expect(controller.after_sign_in_path_for(user)).to eq('/job_providers/dashboard')
    end

    it 'returns the path to the seeker dashboard for a seeker' do
      user = Fabricate(:job_seeker)
      expect(controller.after_sign_in_path_for(user)).to eq('/job_seekers/dashboard')
    end
  end
end
