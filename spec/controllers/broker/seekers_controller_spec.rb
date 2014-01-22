require 'spec_helper'

describe Broker::SeekersController do

  it_should_behave_like 'a protected controller', :broker, :seeker, :all, {
    broker:       -> { Fabricate(:broker_with_regions) },
    seeker:       -> { Fabricate(:seeker, zip: '1234') },
    seeker_attrs: -> {
      attrs = Fabricate.attributes_for(:seeker, zip: '1234')
      attrs[:work_categories].map(&:save)
      attrs[:work_category_ids] = attrs[:work_categories].map(&:id)
      attrs
    }
  }

  describe '#optional_password' do
    let(:seeker) { Fabricate(:seeker, zip: '1234') }

    before do
      authenticate(:broker, Fabricate(:broker_with_regions))
    end

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
