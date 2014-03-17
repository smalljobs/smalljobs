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
      it 'is not valid without a seeker and without a provider' do
        expect(Fabricate.build(:review, seeker: nil, provider: nil)).not_to be_valid
      end

      it 'cannot have two reviews for the same seeker and job' do
        review = Fabricate(:review)
        expect(Fabricate.build(:review,
                               job: review.job,
                               seeker: review.seeker)).not_to be_valid
      end
    end

    describe '#provider' do
      it 'is not valid without a seeker and without a provider' do
        expect(Fabricate.build(:review, seeker: nil, provider: nil)).not_to be_valid
      end

      it 'cannot have two reviews for the same provider and job' do
        review = Fabricate(:review, provider: Fabricate(:provider))
        expect(Fabricate.build(:review,
                               job: review.job,
                               provider: review.provider)).not_to be_valid
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

    describe '#name' do
      context 'with a seeker' do
        let(:review) { Fabricate(:review,
                                      job: Fabricate(:job, title: 'A Job'),
                                      seeker: Fabricate(:seeker, firstname: 'Seeker', lastname: 'A')) }

        it 'combines the seeker name and the job title' do
          expect(review.name).to eql('Seeker A A Job')
        end
      end

      context 'with a provider' do
        let(:review) { Fabricate(:review,
                                      job: Fabricate(:job, title: 'A Job'),
                                      provider: Fabricate(:provider, firstname: 'Provider', lastname: 'A')) }

        it 'combines the provider name and the job title' do
          expect(review.name).to eql('Provider A A Job')
        end
      end
    end
  end
end
