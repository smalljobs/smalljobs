require 'spec_helper'

describe Broker do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:broker)).to be_valid
    end
  end

  context 'attributes' do
    describe '#firstname' do
      it 'is not valid without a firstname' do
        expect(Fabricate.build(:broker, firstname: nil)).not_to be_valid
      end
    end

    describe '#lastname' do
      it 'is not valid without a lastname' do
        expect(Fabricate.build(:broker, lastname: nil)).not_to be_valid
      end
    end

    describe '#email' do
      it 'must be a valid email' do
        expect(Fabricate.build(:broker, email: 'michinetz.ch')).not_to be_valid
        expect(Fabricate.build(:broker, email: 'michi@netzpiraten.ch')).to be_valid
      end
    end

    describe '#phone' do
      it 'is not valid without a phone' do
        expect(Fabricate.build(:broker, phone: nil)).not_to be_valid
      end

      it 'should be a plausible phone number' do
        expect(Fabricate.build(:broker, phone: 'abc123')).not_to be_valid
        expect(Fabricate.build(:broker, phone: '056 496 03 58')).to be_valid
      end

      it 'normalizes the phone number' do
        expect(Fabricate(:broker, phone: '056 496 03 58').phone).to eql('41564960358')
      end
    end

    describe '#mobile' do
      it 'should be a plausible phone number' do
        expect(Fabricate.build(:broker, phone: 'abc123')).not_to be_valid
        expect(Fabricate.build(:broker, phone: '079 244 55 61')).to be_valid
      end

      it 'normalizes the phone number' do
        expect(Fabricate(:broker, phone: "079/244'55'61").phone).to eql('41792445561')
      end
    end

    describe '#active' do
      it 'is active by default' do
        expect(Fabricate(:broker)).to be_active
      end
    end
  end

  describe '#providers' do
    let(:broker) { Fabricate(:broker_with_regions) }

    let!(:my_provider_1)   { Fabricate(:provider, zip: '1234') }
    let!(:my_provider_2)   { Fabricate(:provider, zip: '1235') }
    let!(:my_provider_3)   { Fabricate(:provider, zip: '1236') }

    let!(:not_my_provider) { Fabricate(:provider, zip: '4321') }

    it 'returns the providers in the broker region' do
      expect(broker.providers).to match_array([my_provider_1, my_provider_2, my_provider_3])
      expect(broker.providers).to_not include(not_my_provider)
    end
  end

  describe '#seekers' do
    let(:broker) { Fabricate(:broker_with_regions) }

    let!(:my_seeker_1)   { Fabricate(:seeker, zip: '1234') }
    let!(:my_seeker_2)   { Fabricate(:seeker, zip: '1235') }
    let!(:my_seeker_3)   { Fabricate(:seeker, zip: '1236') }

    let!(:not_my_seeker) { Fabricate(:seeker, zip: '4321') }

    it 'returns the seekers in the broker region' do
      expect(broker.seekers).to match_array([my_seeker_1, my_seeker_2, my_seeker_3])
      expect(broker.seekers).to_not include(not_my_seeker)
    end
  end

  describe '#unauthenticated_message' do
    context 'when confirmed' do
      it 'is inactive' do
        expect(Fabricate(:broker, confirmed: true).unauthenticated_message).to eql(:inactive)
      end
    end

    context 'when unconfirmed' do
      it 'is unconfirmed' do
        expect(Fabricate(:broker, confirmed: false).unauthenticated_message).to eql(:unconfirmed)
      end
    end
  end

  describe '#active_for_authentication?' do
    it 'is not active when not confirmed' do
      expect(Fabricate(:broker, confirmed: false, active: true).active_for_authentication?).to be_false
    end

    it 'is not active when not activated' do
      expect(Fabricate(:broker, confirmed: true, active: false).active_for_authentication?).to be_false
    end

    it 'is active when activated and confirmed' do
      expect(Fabricate(:broker, confirmed: true, active: true).active_for_authentication?).to be_true
    end
  end

  describe "#name" do
    it 'uses the first and last as name' do
      expect(Fabricate(:broker, firstname: 'Otto', lastname: 'Biber').name).to eql('Otto Biber')
    end
  end
end
