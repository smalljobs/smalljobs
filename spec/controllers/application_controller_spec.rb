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

  describe '#current_region' do
    let(:region) { Fabricate(:region) }

    before do
      controller.request.stub(subdomain: region.subdomain)
    end

    it 'returns the current region' do
      expect(controller.send(:current_region)).to eql(region)
    end
  end

  describe '#after_sign_in_path_for' do
    let(:region) { Fabricate(:region_bremgarten) }

    context 'for a broker' do
      let(:employment) { Fabricate(:employment, region: region) }
      let(:broker) { Fabricate(:broker, employments: [employment]) }

      it 'returns the path to the broker dashboard for a broker' do
        expect(controller.send(:after_sign_in_path_for, broker)).to eq('http://bremgarten.test.host/broker/dashboard')
      end
    end

    context 'for a provider' do
      let(:provider) { Fabricate(:provider, place: region.places.first) }

      it 'returns the path to the provider dashboard for a provider' do
        expect(controller.send(:after_sign_in_path_for, provider)).to eq('http://bremgarten.test.host/provider/dashboard')
      end
    end

    context 'for a seeker' do
      let(:seeker) { Fabricate(:seeker, place: region.places.first) }

      it 'returns the path to the seeker dashboard for a seeker' do
        expect(controller.send(:after_sign_in_path_for, seeker)).to eq('http://bremgarten.test.host/seeker/dashboard')
      end
    end

  end

  describe '#ensure_subdomain_for' do
    let(:region) { Fabricate(:region_bremgarten) }

    context 'for a broker' do
      let(:broker) { Fabricate(:broker_with_regions) }

      context 'when the subdomain is valid' do
        before do
          controller.request.stub(subdomain: broker.regions.last.subdomain)
        end

        it 'returns the subdomain' do
          expect(controller.send(:ensure_subdomain_for, broker)).to eq(broker.regions.last.subdomain)
        end
      end

      context 'when the subdomain is invalid' do
        before do
          controller.request.stub(subdomain: 'bern')
        end

        it 'returns the first regions subdomain' do
          expect(controller.send(:ensure_subdomain_for, broker)).to eq(broker.regions.first.subdomain)
        end
      end
    end

    context 'for a provider' do
      let(:provider) { Fabricate(:provider, place: region.places.first) }

      it 'returns the subdomain for the place' do
        expect(controller.send(:ensure_subdomain_for, provider)).to eq('bremgarten')
      end
    end

    context 'for a seeker' do
      let(:seeker) { Fabricate(:seeker, place: region.places.first) }

      it 'returns the subdomain for the place' do
        expect(controller.send(:ensure_subdomain_for, seeker)).to eq('bremgarten')
      end
    end
  end
end
