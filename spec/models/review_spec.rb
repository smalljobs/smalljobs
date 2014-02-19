require 'spec_helper'

describe Review do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:review)).to be_valid
    end
  end

  context 'attributes' do
    describe '#job' do
      it 'is not valid without a job' do
        expect(Fabricate.build(:review, job: nil)).not_to be_valid
      end
    end

    describe '#seeker' do
      it 'is not valid without a seeker' do
        expect(Fabricate.build(:review, seeker: nil)).not_to be_valid
      end
    end

    describe '#rating' do
      it 'is not valid without rating' do
        expect(Fabricate.build(:review, rating: nil)).not_to be_valid
      end

      it 'is only valid within 0 - 5' do
        expect(Fabricate.build(:review, rating: 0)).to be_valid
        expect(Fabricate.build(:review, rating: 5)).to be_valid
        expect(Fabricate.build(:review, rating: 6)).not_to be_valid
      end
    end
  end
end
