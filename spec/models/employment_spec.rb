require 'spec_helper'

describe Employment do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:employment)).to be_valid
    end
  end

  describe '#organization' do
    it 'is not valid without a organization' do
      expect(Fabricate.build(:employment, organization: nil)).not_to be_valid
    end
  end

  describe '#job_broker' do
    it 'is not valid without a job_broker' do
      expect(Fabricate.build(:employment, job_broker: nil)).not_to be_valid
    end
  end

  describe '#region' do
    it 'is not valid without a region' do
      expect(Fabricate.build(:employment, region: nil)).not_to be_valid
    end
  end

  describe '#name' do
    it 'uses the organization and region as name' do
      expect(Fabricate(:employment,
                       organization: Fabricate(:organization, name: 'Lotte'),
                       region: Fabricate(:region, name: 'Muhen')
                      ).name).to eql('Lotte, Muhen')
    end
  end
end
