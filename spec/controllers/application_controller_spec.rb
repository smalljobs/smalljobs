require 'spec_helper'

describe ApplicationController do
  context 'rescues' do
    describe 'CanCan::AccessDenied' do
      controller do
        def index
          raise CanCan::AccessDenied.new('Not allowed')
        end
      end

      it 'shows the access denied details as flash alert' do
        get :index
        expect(flash[:alert]).to eql('Not allowed')
      end

      context 'with a referer' do
        before do
          request.env['HTTP_REFERER'] = '/from-here'
        end

        context 'with a different request uri' do
          before do
            request.env['REQUEST_URI'] = '/different'
          end

          it 'redirects back to the referer' do
            get :index
            expect(response).to redirect_to('/from-here')
          end
        end

        context 'with the same request uri' do
          before do
            request.env['REQUEST_URI'] = '/from-here'
          end

          it 'redirects back to the home page' do
            get :index
            expect(response).to redirect_to('/')
          end
        end
      end

      context 'without a referer' do
        before do
          request.env['HTTP_REFERER'] = nil
        end

        it 'redirects back to the home page' do
          get :index
          expect(response).to redirect_to('/')
        end
      end
    end
  end

  describe '#current_user' do
    context 'with a logged in admin' do
      auth_admin(:admin) { Fabricate(:admin) }

      it 'returns the admin' do
        expect(controller.send(:current_user)).to eq(admin)
      end
    end

    context 'with a logged in broker' do
      auth_broker(:broker) { Fabricate(:broker) }

      it 'returns the broker' do
        expect(controller.send(:current_user)).to eq(broker)
      end
    end

    context 'with a logged in provider' do
      auth_provider(:provider) { Fabricate(:provider) }

      it 'returns the provider' do
        expect(controller.send(:current_user)).to eq(provider)
      end
    end

    context 'with a logged in seeker' do
      auth_seeker(:seeker) { Fabricate(:seeker) }

      it 'returns the seeker' do
        expect(controller.send(:current_user)).to eq(seeker)
      end
    end
  end

  describe '#after_sign_in_path_for' do
    it 'returns the path to the broker dashboard for a broker' do
      user = Fabricate(:broker)
      expect(controller.send(:after_sign_in_path_for, user)).to eq('/broker/dashboard')
    end

    it 'returns the path to the provider dashboard for a provider' do
      user = Fabricate(:provider)
      expect(controller.send(:after_sign_in_path_for, user)).to eq('/provider/dashboard')
    end

    it 'returns the path to the seeker dashboard for a seeker' do
      user = Fabricate(:seeker)
      expect(controller.send(:after_sign_in_path_for, user)).to eq('/seeker/dashboard')
    end
  end
end
