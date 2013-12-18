require 'spec_helper'

describe OmniauthCallbacksController do

  describe '#facebook' do
    before do
      request.env['devise.mapping'] = Devise.mappings[:job_seeker]
    end

    context 'with persisted user' do
      context 'which is confirmed and activated' do
        before do
          JobSeeker.stub(:find_for_facebook_oauth).and_return(Fabricate(:job_seeker, confirmed: true, active: true))
          get :facebook
        end

        it 'redirects the user to its dashboard' do
          expect(response).to redirect_to('/job_seekers/dashboard')
        end
      end

      context 'which is not confirmed' do
        before do
          JobSeeker.stub(:find_for_facebook_oauth).and_return(Fabricate(:job_seeker, confirmed: false, active: true))
          get :facebook
        end

        it 'redirects the user to the home page' do
          expect(response).to redirect_to('/')
        end
      end

      context 'which is not activated' do
        before do
          JobSeeker.stub(:find_for_facebook_oauth).and_return(Fabricate(:job_seeker, confirmed: true, active: false))
          get :facebook
        end

        it 'redirects the user to the home page' do
          expect(response).to redirect_to('/')
        end
      end
    end

    context 'with a user that cannot be persisted' do
      before do
        JobSeeker.stub(:find_for_facebook_oauth).and_return(Fabricate.build(:job_seeker))
        get :facebook
      end

      it 'redirects to the job seeker registration' do
        expect(response).to redirect_to('/job_seekers/sign_up')
      end
    end
  end

end
