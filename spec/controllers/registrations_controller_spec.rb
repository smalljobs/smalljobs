require 'spec_helper'

describe RegistrationsController do
  describe '#new' do
    context 'for a job broker' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:job_broker]
        get :new
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to('/')
      end

      it 'notifies that registration is not possible' do
        expect(flash[:alert]).to eql('Sie können sich nicht selber als Anbieter registrieren. Bitte kontaktieren Sie uns unter hello@smalljobs.ch')
      end
    end

    context 'for a job provider' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:job_provider]
        get :new
      end

      it 'renders the registration form' do
        expect(subject).to render_template('job_providers/registrations/new')
      end
    end

    context 'for a job seeker' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:job_seeker]
        get :new
      end

      it 'renders the registration form' do
        expect(subject).to render_template('job_seekers/registrations/new')
      end
    end
  end
end
