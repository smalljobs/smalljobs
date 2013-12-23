shared_examples_for 'a protected controller' do |role, resource, actions|

  if actions == :all
    actions = [:index, :new, :create, :show, :edit, :update, :destroy]
  else
    actions = Array(action)
  end

  ([:anonymous, :broker, :provider, :seeker] - [role]).each do |scope|

    context  "for a #{ scope }" do
      before do
        authenticate(scope, Fabricate(scope)) unless scope == :anonymous
      end

      if actions.include?(:index)
        it 'does not allow to list all resources' do
          get :index
          expect(response).to redirect_to("/#{ role.to_s.pluralize }/sign_in")
        end
      end

      if actions.include?(:new)
        it 'does not allow to build a new resource' do
          get :new
          expect(response).to redirect_to("/#{ role.to_s.pluralize }/sign_in")
        end
      end

      if actions.include?(:create)
        let(:create_attributes) { Fabricate.attributes_for(resource) }

        it 'does not allow to create a new resource' do
          post :create, create_attributes
          expect(response).to redirect_to("/#{ role.to_s.pluralize }/sign_in")
        end
      end

      if actions.include?(:show)
        let(:show_resource) { Fabricate(resource) }

        it 'does not allow to show a resource' do
          get :show, id: show_resource
          expect(response).to redirect_to("/#{ role.to_s.pluralize }/sign_in")
        end
      end

      if actions.include?(:edit)
        let(:edit_resource) { Fabricate(resource) }

        it 'does not allow to edit a resource' do
          get :edit, id: edit_resource.id
          expect(response).to redirect_to("/#{ role.to_s.pluralize }/sign_in")
        end
      end

      if actions.include?(:update)
        let(:update_resource) { Fabricate(resource) }

        it 'does not allow to update a resource' do
          params = { id: update_resource.id }
          params[resource] = update_resource.attributes

          patch :update, params
          expect(response).to redirect_to("/#{ role.to_s.pluralize }/sign_in")
        end
      end

      if actions.include?(:destroy)
        let(:destroy_resource) { Fabricate(resource) }

        it 'does not allow to destroy a resoures' do
          delete :destroy, id: destroy_resource.id
          expect(response).to redirect_to("/#{ role.to_s.pluralize }/sign_in")
        end
      end
    end
  end

  context  "for a #{ role }" do
    before do
      authenticate(role, Fabricate(role)) unless role == :anonymous
    end

    if actions.include?(:index)
      it 'does allow to list all resources' do
        get :index
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:new)
      it 'doea allow to build a new resource' do
        get :new
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:create)
      let(:create_attributes) { Fabricate.attributes_for(resource) }

      it 'does allow to create a new resource' do
        post :create, create_attributes
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:show)
      let(:show_resource) { Fabricate(resource) }

      it 'does allow to show a resource' do
        get :show, id: show_resource.id
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:edit)
      let(:edit_resource) { Fabricate(resource) }

      it 'does allow to edit a resource' do
        get :edit, id: edit_resource.id
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:update)
      let(:update_resource) { Fabricate(resource) }

      it 'does allow to update a resource' do
        params = { id: update_resource.id }
        params[resource] = update_resource.attributes

        patch :update, params
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:destroy)
      let(:destroy_resource) { Fabricate(resource) }

      it 'does allow to destroy a resoures' do
        delete :destroy, id: destroy_resource.id
        expect(response.status).to eql(200)
      end
    end
  end
end
