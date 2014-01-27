require 'spec_helper'

describe Broker do

  it_should_behave_like 'a confirm toggle'

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
