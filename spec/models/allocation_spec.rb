require 'spec_helper'

describe Allocation do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:allocation)).to be_valid
    end
  end

  context 'attributes' do
    describe '#job' do
      it 'is not valid without a job' do
        expect(Fabricate.build(:allocation, job: nil)).not_to be_valid
      end
    end

    describe '#seeker' do
      it 'is not valid without a seeker' do
        expect(Fabricate.build(:allocation, seeker: nil)).not_to be_valid
      end
    end
  end
end
