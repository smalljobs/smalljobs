require 'spec_helper'

describe Broker::SeekersController do

  it_behaves_like 'a protected controller', :broker, :seeker, :all do
    let(:broker) { Fabricate(:broker_with_regions) }
    let(:seeker) { Fabricate(:seeker, place: broker.places.first) }
    let(:seeker_attrs) do
      attrs = Fabricate.attributes_for(:seeker, place: broker.places.first)
      attrs[:work_categories].map(&:save)
      attrs[:work_category_ids] = attrs[:work_categories].map(&:id)
      attrs
    end
  end

  describe '#index' do
    auth_broker(:broker) { Fabricate(:broker_with_regions) }

    before do
      Fabricate(:seeker, place: broker.places.first)
      Fabricate(:seeker, place: broker.places.last)
      Fabricate(:seeker, place: Fabricate(:place, zip: '9999'))
    end

    it 'shows only seekers in the broker regions' do
      get :index
      expect(assigns(:seekers).count).to eql(2)
    end
  end

  describe '#optional_password' do
    auth_broker(:broker) { Fabricate(:broker_with_regions) }
    let(:seeker) { Fabricate(:seeker, place: broker.places.first) }

    context 'without a password' do
      let(:attributes) do
        attributes = seeker.attributes
        attributes['firstname'] = 'A test'
        attributes.delete(:password)
        attributes.delete(:password_confirmation)
        attributes
      end

      it 'saves the update data' do
        patch :update, id: seeker.id, seeker: attributes
        seeker.reload
        expect(seeker.firstname).to eql('A test')
      end

      it 'redirects to the updated seeker' do
        patch :update, id: seeker.id, seeker: attributes
        expect(response).to redirect_to(broker_seeker_path(seeker))
      end
    end

    context 'with a password' do
      context 'that is not confirmed' do
        let(:attributes) do
          attributes = seeker.attributes
          attributes['firstname'] = 'A test'
          attributes['password'] = 'tester1234'
          attributes['password_confirmation'] = 'tester'
          attributes
        end

        it 'does not save the updated data' do
          patch :update, id: seeker.id, seeker: attributes
          seeker.reload
          expect(seeker.firstname).to_not eql('A test')
        end
      end

      context 'that is confirmed' do
        let(:attributes) do
          attributes = seeker.attributes
          attributes['firstname'] = 'A test'
          attributes['password'] = 'tester1234'
          attributes['password_confirmation'] = 'tester1234'
          attributes
        end

        it 'does save the updated data' do
          patch :update, id: seeker.id, seeker: attributes
          seeker.reload
          expect(seeker.firstname).to eql('A test')
          expect(seeker.valid_password?('tester1234')).to be_true
        end
      end
    end
  end
end
