require 'spec_helper'

describe Application do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:application)).to be_valid
    end
  end

  context 'attributes' do
    describe '#job' do
      it 'is not valid without a job' do
        expect(Fabricate.build(:application, job: nil)).not_to be_valid
      end
    end

    describe '#seeker' do
      it 'is not valid without a seeker' do
        expect(Fabricate.build(:application, seeker: nil)).not_to be_valid
      end

      it 'cannot have two to applications for the same seeker and job' do
        application = Fabricate(:application)
        expect(Fabricate.build(:application,
                               job: application.job,
                               seeker: application.seeker)).not_to be_valid
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
