require 'spec_helper'

describe Place do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:place)).to be_valid
    end
  end

  describe '#zip' do
    it 'is not valid without a zip' do
      expect(Fabricate.build(:place, zip: nil)).not_to be_valid
    end
  end

  describe '#name' do
    it 'is not valid without a name' do
      expect(Fabricate.build(:place, name: nil)).not_to be_valid
    end
  end

  describe '#longitude' do
    it 'is not valid without a longitude' do
      expect(Fabricate.build(:place, longitude: nil)).not_to be_valid
    end
  end

  describe '#latitude' do
    it 'is not valid without a latitude' do
      expect(Fabricate.build(:place, latitude: nil)).not_to be_valid
    end
  end
end
