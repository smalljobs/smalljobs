require 'spec_helper'

describe WorkCategory do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:work_category)).to be_valid
    end
  end

  describe '#name' do
    it 'is not valid without a name' do
      expect(Fabricate.build(:work_category, name: nil)).not_to be_valid
    end
  end
end
