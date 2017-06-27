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

      it 'cannot have two allocations for the same seeker and job' do
        allocation = Fabricate(:allocation)
        expect(Fabricate.build(:allocation,
                               job: allocation.job,
                               seeker: allocation.seeker)).not_to be_valid
      end
    end

    describe '#name' do
      let(:allocation) { Fabricate(:allocation,
                                 job: Fabricate(:job, title: 'A Job'),
                                 seeker: Fabricate(:seeker, firstname: 'Seeker', lastname: 'A')) }

      it 'combines the seeker name and the job title' do
        expect(allocation.name).to eql('Seeker A A Job')
      end
    end
  end

end
