require 'spec_helper'

describe JobBroker do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:job_broker)).to be_valid
    end
  end

  describe '#firstname' do
    it 'is not valid without a firstname' do
      expect(Fabricate.build(:job_broker, firstname: nil)).not_to be_valid
    end
  end

  describe '#lastname' do
    it 'is not valid without a lastname' do
      expect(Fabricate.build(:job_broker, lastname: nil)).not_to be_valid
    end
  end

  describe '#email' do
    it 'must be a valid email' do
      expect(Fabricate.build(:job_broker, email: 'michinetz.ch')).not_to be_valid
      expect(Fabricate.build(:job_broker, email: 'michi@netzpiraten.ch')).to be_valid
    end
  end

  describe '#phone' do
    it 'is not valid without a phone' do
      expect(Fabricate.build(:job_broker, phone: nil)).not_to be_valid
    end

    it 'should be a plausible phone number' do
      expect(Fabricate.build(:job_broker, phone: 'abc123')).not_to be_valid
      expect(Fabricate.build(:job_broker, phone: '056 496 03 58')).to be_valid
    end

    it 'normalizes the phone number' do
      expect(Fabricate(:job_broker, phone: '056 496 03 58').phone).to eql('41564960358')
    end
  end

  describe '#mobile' do
    it 'should be a plausible phone number' do
      expect(Fabricate.build(:job_broker, phone: 'abc123')).not_to be_valid
      expect(Fabricate.build(:job_broker, phone: '079 244 55 61')).to be_valid
    end

    it 'normalizes the phone number' do
      expect(Fabricate(:job_broker, phone: "079/244'55'61").phone).to eql('41792445561')
    end
  end

  describe '#active' do
    it 'is active by default' do
      expect(Fabricate(:job_broker)).to be_active
    end
  end

end
