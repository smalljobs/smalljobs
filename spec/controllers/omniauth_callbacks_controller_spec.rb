require 'spec_helper'

describe OmniauthCallbacksController do

  describe '#facebook' do
    before do
      request.env['devise.mapping'] = Devise.mappings[:seeker]
    end

    context 'with persisted user' do
      let(:region) { Fabricate(:region_bremgarten) }

      context 'which is confirmed and activated' do
        before do
          Seeker.stub(:find_for_facebook_oauth).and_return(Fabricate(:seeker, place: region.places.first, confirmed: true, active: true))
          get :facebook
        end

        it 'redirects the user to its dashboard' do
          expect(response).to redirect_to('http://bremgarten.test.host/seeker/dashboard')
        end
      end

      context 'which is not confirmed' do
        before do
          Seeker.stub(:find_for_facebook_oauth).and_return(Fabricate(:seeker, confirmed: false, active: true))
          get :facebook
        end

        it 'redirects the user to the home page' do
          expect(response).to redirect_to('/')
        end
      end

      context 'which is not activated' do
        before do
          Seeker.stub(:find_for_facebook_oauth).and_return(Fabricate(:seeker, confirmed: true, active: false))
          get :facebook
        end

        it 'redirects the user to the home page' do
          expect(response).to redirect_to('/')
        end
      end
    end

    context 'with a user that cannot be persisted' do
      before do
        Seeker.stub(:find_for_facebook_oauth).and_return(Fabricate.build(:seeker))
        get :facebook
      end

      it 'redirects to the job seeker registration' do
        expect(response).to redirect_to('/seekers/sign_up')
      end
    end
  end

end
