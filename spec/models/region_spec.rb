require_relative '../spec_helper'

describe Region do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:region)).to be_valid
    end
  end

  describe '#name' do
    it 'is not valid without a name' do
      expect(Fabricate.build(:region, name: nil)).not_to be_valid
    end

    it 'must be a unique name' do
      Fabricate(:region, name: 'Yo Land')
      expect(Fabricate.build(:region, name: 'Yo Land')).not_to be_valid
    end
  end

  describe '#subdomain' do
    it 'is not valid without a subname' do
      expect(Fabricate.build(:region, subdomain: nil)).not_to be_valid
    end

    it 'must be a valid subdomain' do
      expect(Fabricate.build(:region, subdomain: 'Yo Land')).not_to be_valid
    end
  end

  describe '#places' do
    it 'needs at least one place' do
      expect(Fabricate.build(:region, places: [])).not_to be_valid
    end
  end
end
