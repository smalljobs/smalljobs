require 'spec_helper'

describe Broker::ProvidersController do
  #it_should_behave_like 'a protected controller', :broker, :provider, :all

  describe '#optional_password' do
    let(:provider) { Fabricate(:provider, zip: '1234') }

    before do
      authenticate(:broker, Fabricate(:broker_with_regions))
    end

    context 'without a password' do
      let(:attributes) do
        attributes = provider.attributes
        attributes['firstname'] = 'A test'
        attributes.delete(:password)
        attributes.delete(:password_confirmation)
        attributes
      end

      it 'saves the update data' do
        patch :update, id: provider.id, provider: attributes
        provider.reload
        expect(provider.firstname).to eql('A test')
      end

      it 'redirects to the updated provider' do
        patch :update, id: provider.id, provider: attributes
        expect(response).to redirect_to(broker_provider_path(provider))
      end
    end

    context 'with a password' do
      context 'that is not confirmed' do
        let(:attributes) do
          attributes = provider.attributes
          attributes['firstname'] = 'A test'
          attributes['password'] = 'tester1234'
          attributes['password_confirmation'] = 'tester'
          attributes
        end

        it 'does not save the updated data' do
          patch :update, id: provider.id, provider: attributes
          provider.reload
          expect(provider.firstname).to_not eql('A test')
        end
      end

      context 'that is confirmed' do
        let(:attributes) do
          attributes = provider.attributes
          attributes['firstname'] = 'A test'
          attributes['password'] = 'tester1234'
          attributes['password_confirmation'] = 'tester1234'
          attributes
        end

        it 'does save the updated data' do
          patch :update, id: provider.id, provider: attributes
          provider.reload
          expect(provider.firstname).to eql('A test')
          expect(provider.valid_password?('tester1234')).to be_true
        end
      end
    end
  end
end
