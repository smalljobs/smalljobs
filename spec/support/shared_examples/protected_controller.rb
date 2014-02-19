shared_examples_for 'a protected controller' do |role, resource, actions|

  if actions == :all
    actions = [:index, :new, :create, :show, :edit, :update, :destroy]
  else
    actions = Array(actions)
  end

  ([:anonymous, :broker, :provider, :seeker] - [role]).each do |scope|

    context  "for a #{ scope }" do
      let(:login_user) { send(scope) rescue Fabricate(scope) }

      before do
        authenticate(scope, login_user) unless scope == :anonymous
      end

      if actions.include?(:index)
        it 'does not allow to list all resources' do
          xhr :get, :index, format: :json
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:new)
        it 'does not allow to build a new resource' do
          xhr :get, :new, format: :json
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:create)
        let(:create_attributes) do
          send("#{ resource }_attrs") rescue Fabricate.attributes_for(resource)
        end

        it 'does not allow to create a new resource' do
          params = { format: :json }
          params[resource] = create_attributes

          xhr :post, :create, params
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:show)
        let(:show_resource) { send(resource) rescue Fabricate(resource) }

        it 'does not allow to show a resource' do
          xhr :get, :show, id: show_resource, format: :json
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:edit)
        let(:edit_resource) { send(resource) rescue Fabricate(resource) }

        it 'does not allow to edit a resource' do
          xhr :get, :edit, id: edit_resource.id, format: :json
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:update)
        let(:update_resource) { send(resource) rescue Fabricate(resource) }

        it 'does not allow to update a resource' do
          params = { id: update_resource.id, format: :json }
          params[resource] = update_resource.attributes

          xhr :patch, :update, params
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:destroy)
        let(:destroy_resource) { send(resource) rescue Fabricate(resource) }

        it 'does not allow to destroy a resoures' do
          xhr :delete, :destroy, id: destroy_resource.id, format: :json
          expect(response.status).to eql(401)
        end
      end
    end
  end

  context  "for a #{ role }" do
    let(:login_user) { send(role) rescue Fabricate(role) }

    before do
      authenticate(role, login_user) unless role == :anonymous
    end

    if actions.include?(:index)
      it 'does allow to list all resources' do
        xhr :get, :index, format: :json
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:new)
      it 'does allow to build a new resource' do
        xhr :get, :new, format: :json
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:create)
      let(:create_attributes) do
        send("#{ resource }_attrs") rescue Fabricate.attributes_for(resource)
      end

      it 'does allow to create a new resource' do
        params = { format: :json }
        params[resource] = create_attributes

        xhr :post, :create, params
        expect(response.status).to eql(201)
      end
    end

    if actions.include?(:show)
      let(:show_resource) { send(resource) rescue Fabricate(resource) }

      it 'does allow to show a resource' do
        xhr :get, :show, id: show_resource.id, format: :json
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:edit)
      let(:edit_resource) { send(resource) rescue Fabricate(resource) }

      it 'does allow to edit a resource' do
        xhr :get, :edit, id: edit_resource.id, format: :json
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:update)
      let(:update_resource) { send(resource) rescue Fabricate(resource) }

      it 'does allow to update a resource' do
        params = { id: update_resource.id, format: :json }
        params[resource] = update_resource.attributes

        xhr :patch, :update, params
        expect(response.status).to eql(204)
      end
    end

    if actions.include?(:destroy)
      let(:destroy_resource) { send(resource) rescue Fabricate(resource) }

      it 'does allow to destroy a resoures' do
        xhr :delete, :destroy, id: destroy_resource.id, format: :json
        expect(response.status).to eql(204)
      end
    end
  end
end
