require 'spec_helper'

describe Organization do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:organization)).to be_valid
    end
  end

  describe '#name' do
    it 'is not valid without a name' do
      expect(Fabricate.build(:organization, name: nil)).not_to be_valid
    end

    it 'must be a unique name' do
      Fabricate(:organization, name: 'Lotte')
      expect(Fabricate.build(:organization, name: 'Lotte')).not_to be_valid
    end
  end

  describe '#website' do
    it 'is not valid without a website' do
      expect(Fabricate.build(:organization, website: nil)).not_to be_valid
    end

    it 'must be a valid url' do
      expect(Fabricate.build(:organization, website: 'something')).not_to be_valid
      expect(Fabricate.build(:organization, website: 'http://www.google.ch')).to be_valid
    end
  end

  describe '#street' do
    it 'is not valid without a street' do
      expect(Fabricate.build(:organization, street: nil)).not_to be_valid
    end
  end

  describe '#zip' do
    it 'is not valid without a zip' do
      expect(Fabricate.build(:organization, zip: nil)).not_to be_valid
    end

    it 'must conform to Swiss zip format' do
      expect(Fabricate.build(:organization, zip: '123a')).not_to be_valid
      expect(Fabricate.build(:organization, zip: '123')).not_to be_valid
      expect(Fabricate.build(:organization, zip: '12345')).not_to be_valid
      expect(Fabricate.build(:organization, zip: '1')).not_to be_valid

      expect(Fabricate.build(:organization, zip: '1234')).to be_valid
    end
  end

  describe '#city' do
    it 'is not valid without a city' do
      expect(Fabricate.build(:organization, city: nil)).not_to be_valid
    end
  end

  describe '#email' do
    it 'is not valid without a email' do
      expect(Fabricate.build(:organization, email: nil)).not_to be_valid
    end

    it 'must be a valid email' do
      expect(Fabricate.build(:organization, email: 'michinetz.ch')).not_to be_valid
      expect(Fabricate.build(:organization, email: 'michi@netzpiraten.ch')).to be_valid
    end
  end

  describe '#phone' do
    it 'should be a plausible phone number' do
      expect(Fabricate.build(:organization, phone: 'abc123')).not_to be_valid
      expect(Fabricate.build(:organization, phone: '056 496 03 58')).to be_valid
    end

    it 'normalizes the phone number' do
      expect(Fabricate(:organization, phone: '056 496 03 58').phone).to eql('41564960358')
    end
  end

  describe '#active' do
    it 'is active by default' do
      expect(Fabricate(:organization)).to be_active
    end
  end
end
