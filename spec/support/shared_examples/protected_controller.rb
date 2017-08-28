shared_examples_for 'a protected controller' do |role, resource, actions|

  let(:params) { {} }

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
          p = { format: :json }.merge(params)

          xhr :get, :index, p
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:new)
        it 'does not allow to build a new resource' do
          p = { format: :json }.merge(params)

          xhr :get, :new, p
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:create)
        let(:create_attributes) do
          send("#{ resource }_attrs") rescue Fabricate.attributes_for(resource)
        end

        it 'does not allow to create a new resource' do
          p = { format: :json }.merge(params)
          p[resource] = create_attributes

          xhr :post, :create, p
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:show)
        let(:show_resource) { send(resource) rescue Fabricate(resource) }

        it 'does not allow to show a resource' do
          p = { format: :json, id: show_resource.id }.merge(params)

          xhr :get, :show, p
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:edit)
        let(:edit_resource) { send(resource) rescue Fabricate(resource) }

        it 'does not allow to edit a resource' do
          p = { format: :json, id: edit_resource.id }.merge(params)

          xhr :get, :edit, p
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:update)
        let(:update_resource) { send(resource) rescue Fabricate(resource) }

        it 'does not allow to update a resource' do
          p = { id: update_resource.id, format: :json }.merge(params)
          p[resource] = update_resource.attributes

          xhr :patch, :update, p
          expect(response.status).to eql(401)
        end
      end

      if actions.include?(:destroy)
        let(:destroy_resource) { send(resource) rescue Fabricate(resource) }

        it 'does not allow to destroy a resoures' do
          p = { format: :json, id: destroy_resource.id }.merge(params)

          xhr :delete, :destroy, p
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
        p = { format: :json }.merge(params)

        xhr :get, :index, p
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:create)
      let(:create_attributes) do
        send("#{ resource }_attrs") rescue Fabricate.attributes_for(resource)
      end

      it 'does allow to create a new resource' do
        p = { format: :json }.merge(params)
        p[resource] = create_attributes

        xhr :post, :create, p
        expect(response.status).to eql(201)
      end
    end

    if actions.include?(:show)
      let(:show_resource) { send(resource) rescue Fabricate(resource) }

      it 'does allow to show a resource' do
        p = { format: :json, id: show_resource.id }.merge(params)

        xhr :get, :show, p
        expect(response.status).to eql(302)
      end
    end

    if actions.include?(:edit)
      let(:edit_resource) { send(resource) rescue Fabricate(resource) }

      it 'does allow to edit a resource' do
        p = { format: :json, id: edit_resource.id }.merge(params)

        xhr :get, :edit, p
        expect(response.status).to eql(200)
      end
    end

    if actions.include?(:update)
      let(:update_resource) { send(resource) rescue Fabricate(resource) }

      it 'does allow to update a resource' do
        p = { id: update_resource.id, format: :json }.merge(params)
        p[resource] = update_resource.attributes

        xhr :patch, :update, p
        expect(response.status).to eql(204)
      end
    end

    if actions.include?(:destroy)
      let(:destroy_resource) { send(resource) rescue Fabricate(resource) }

      it 'does allow to destroy a resoures' do
        p = { id: destroy_resource.id, format: :json }.merge(params)

        xhr :delete, :destroy, p
        expect(response.status).to eql(204)
      end
    end
  end
end
