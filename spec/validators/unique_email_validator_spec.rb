require 'spec_helper'

describe UniqueEmailValidator do
  describe '#validate' do
    context "for a job broker" do
      it 'prohibits signup with a confirmed provider email' do
        Fabricate(:job_provider, email: 'used@example.com')
        expect(Fabricate.build(:job_broker, email: 'used@example.com')).to_not be_valid
      end

      it 'prohibits signup with an unconfirmed provider email' do
        Fabricate(:job_provider, unconfirmed_email: 'used@example.com')
        expect(Fabricate.build(:job_broker, email: 'used@example.com')).to_not be_valid
      end

      it 'prohibits signup with a confirmed seeker email' do
        Fabricate(:job_seeker, email: 'used@example.com')
        expect(Fabricate.build(:job_broker, email: 'used@example.com')).to_not be_valid
      end

      it 'prohibits signup with an unconfirmed seeker email' do
        Fabricate(:job_seeker, unconfirmed_email: 'used@example.com')
        expect(Fabricate.build(:job_broker, email: 'used@example.com')).to_not be_valid
      end
    end

    context "for a job provider" do
      it 'prohibits signup with a confirmed broker email' do
        Fabricate(:job_broker, email: 'used@example.com')
        expect(Fabricate.build(:job_provider, email: 'used@example.com')).to_not be_valid
      end

      it 'prohibits signup with an unconfirmed broker email' do
        Fabricate(:job_broker, unconfirmed_email: 'used@example.com')
        expect(Fabricate.build(:job_provider, email: 'used@example.com')).to_not be_valid
      end

      it 'prohibits signup with a confirmed seeker email' do
        Fabricate(:job_seeker, email: 'used@example.com')
        expect(Fabricate.build(:job_provider, email: 'used@example.com')).to_not be_valid
      end

      it 'prohibits signup with an unconfirmed seeker email' do
        Fabricate(:job_seeker, unconfirmed_email: 'used@example.com')
        expect(Fabricate.build(:job_provider, email: 'used@example.com')).to_not be_valid
      end
    end

    context "for a job seeker" do
      it 'prohibits signup with a confirmed broker email' do
        Fabricate(:job_broker, email: 'used@example.com')
        expect(Fabricate.build(:job_seeker, email: 'used@example.com')).to_not be_valid
      end

      it 'prohibits signup with an unconfirmed broker email' do
        Fabricate(:job_broker, unconfirmed_email: 'used@example.com')
        expect(Fabricate.build(:job_seeker, email: 'used@example.com')).to_not be_valid
      end

      it 'prohibits signup with a confirmed provider email' do
        Fabricate(:job_provider, email: 'used@example.com')
        expect(Fabricate.build(:job_seeker, email: 'used@example.com')).to_not be_valid
      end

      it 'prohibits signup with an unconfirmed provider email' do
        Fabricate(:job_provider, unconfirmed_email: 'used@example.com')
        expect(Fabricate.build(:job_seeker, email: 'used@example.com')).to_not be_valid
      end
    end
  end
end
