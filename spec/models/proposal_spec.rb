require 'spec_helper'

describe Proposal do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:proposal)).to be_valid
    end
  end

  context 'attributes' do
    describe '#job' do
      it 'is not valid without a job' do
        expect(Fabricate.build(:proposal, job: nil)).not_to be_valid
      end
    end

    describe '#seeker' do
      it 'is not valid without a seeker' do
        expect(Fabricate.build(:proposal, seeker: nil)).not_to be_valid
      end

      it 'cannot give to proposals for the same seeker and job' do
        proposal = Fabricate(:proposal)
        expect(Fabricate.build(:proposal,
                               job: proposal.job,
                               seeker: proposal.seeker)).not_to be_valid
      end
    end
  end

  describe '#name' do
    let(:proposal) { Fabricate(:proposal,
                               job: Fabricate(:job, title: 'A Job'),
                               seeker: Fabricate(:seeker, firstname: 'Seeker', lastname: 'A')) }

    it 'combines the seeker name and the job title' do
      expect(proposal.name).to eql('Seeker A A Job')
    end
  end
end
