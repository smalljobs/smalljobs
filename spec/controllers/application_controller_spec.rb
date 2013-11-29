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
end
