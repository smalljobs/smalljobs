require_relative '../spec_helper'

describe ApplicationController, type: :controller do
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

      context 'without referer' do
        context 'within the /admin path' do
          before do
            request.env['HTTP_REFERER'] = nil
            request.stub(path: '/admin')
          end

          it 'redirects back to the home page' do
            get :index
            expect(response).to redirect_to('/')
          end
        end

        context 'within the /broker path' do
          before do
            request.env['HTTP_REFERER'] = nil
            request.stub(path: '/broker')
          end

          it 'redirects to the broker login' do
            get :index
            expect(response).to redirect_to('/')
          end
        end

        context 'within the /provider path' do
          before do
            request.env['HTTP_REFERER'] = nil
            request.stub(path: '/provider')
          end

          it 'returns to the provider login' do
            get :index
            expect(response).to redirect_to('/')
          end
        end

        context 'within the /seeker path' do
          before do
            request.env['HTTP_REFERER'] = nil
            request.stub(path: '/seeker')
          end

          it 'redirects to the seeker login' do
            get :index
            expect(response).to redirect_to('/')
          end
        end

        context 'without a known path' do
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
  end

  describe '#current_user' do
    context 'with a broker scope' do
      let(:broker) { Fabricate(:broker) }

      before do
        controller.stub({
          resource_name: :broker,
          current_broker: broker
        })
      end

      it 'returns the current broker' do
        expect(controller.send(:current_user)).to eql(broker)
      end
    end

    context 'with a provider scope' do
      let(:provider) { Fabricate(:provider) }

      before do
        controller.stub({
          resource_name: :provider,
          current_provider: provider
        })
      end

      it 'returns the current provider' do
        expect(controller.send(:current_user)).to eql(provider)
      end
    end

    context 'with a seeker scope' do
      let(:seeker) { Fabricate(:seeker) }

      before do
        controller.stub({
          resource_name: :seeker,
          current_seeker: seeker
        })
      end

      it 'returns the current seeker' do
        expect(controller.send(:current_user)).to eql(seeker)
      end
    end

    context 'without a scope' do
      let(:admin) { Fabricate(:admin) }

      before do
        controller.stub({
          current_admin: admin
        })
      end

      it 'returns the current admin' do
        expect(controller.send(:current_user)).to eql(admin)
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
        expect(controller.send(:after_sign_in_path_for, broker)).to eq('http://test.host/broker/dashboard')
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

    context 'for an admihn' do
      let(:admin) { Fabricate(:admin) }

      it 'returns the path to the admin dashboard for a admin' do
        expect(controller.send(:after_sign_in_path_for, admin)).to eq('http://test.host/admin/')
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
