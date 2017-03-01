require 'spec_helper'

describe Job do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:job)).to be_valid
    end
  end

  context 'attributes' do
    describe '#provider' do
      it 'is not valid without a provider' do
        expect(Fabricate.build(:job, provider: nil)).not_to be_valid
      end
    end

    describe '#work_category' do
      it 'is not valid without a work category' do
        expect(Fabricate.build(:job, work_category: nil)).not_to be_valid
      end
    end

    describe '#state' do
      it 'must be one of created, available, connected or rated' do
        expect(Fabricate.build(:job, state: 'abc123')).not_to be_valid
        expect(Fabricate.build(:job, state: 'created')).to be_valid
        expect(Fabricate.build(:job, state: 'available')).to be_valid
        expect(Fabricate.build(:job, state: 'connected')).to be_valid
        expect(Fabricate.build(:job, state: 'rated')).to be_valid
      end
    end

    describe '#title' do
      it 'is not valid without a title' do
        expect(Fabricate.build(:job, title: nil)).not_to be_valid
      end
    end

    describe '#date_type' do
      it 'must be one of agreement, date or date_range' do
        expect(Fabricate.build(:job, date_type: 'abc123')).not_to be_valid
        expect(Fabricate.build(:job, date_type: 'agreement')).to be_valid
        expect(Fabricate.build(:job, date_type: 'date')).to be_valid
        expect(Fabricate.build(:job, date_type: 'date_range')).to be_valid
      end
    end

    describe '#start_date' do
      it 'is not required with a date type of agreement' do
        expect(Fabricate.build(:job, date_type: 'agreement', start_date: nil)).to be_valid
      end

      it 'is required with a date type of date' do
        expect(Fabricate.build(:job, date_type: 'date', start_date: nil)).not_to be_valid
      end

      it 'is required with a date type of date range' do
        expect(Fabricate.build(:job, date_type: 'date_range', start_date: nil)).not_to be_valid
      end
    end

    describe '#end_date' do
      it 'is not required with a date type of agreement' do
        expect(Fabricate.build(:job, date_type: 'agreement', end_date: nil)).to be_valid
      end

      it 'is not required with a date type of date' do
        expect(Fabricate.build(:job, date_type: 'date', end_date: nil)).to be_valid
      end

      it 'is required with a date type of date range' do
        expect(Fabricate.build(:job, date_type: 'date_range', end_date: nil)).not_to be_valid
      end
    end

    describe '#salary' do
      it 'is not valid without a salary' do
        expect(Fabricate.build(:job, salary: nil)).not_to be_valid
      end
    end

    describe '#salary_type' do
      it 'must be either hourly or fixed' do
        expect(Fabricate.build(:job, salary_type: 'abc123')).not_to be_valid
        expect(Fabricate.build(:job, salary_type: 'hourly')).to be_valid
        expect(Fabricate.build(:job, salary_type: 'fixed')).to be_valid
        expect(Fabricate.build(:job, salary_type: 'hourly_per_age')).to be_valid
      end
    end


    describe '#manpower' do
      it 'is not valid without manpower' do
        expect(Fabricate.build(:job, manpower: nil)).not_to be_valid
      end

      it 'is not valid with a manpower of 0' do
        expect(Fabricate.build(:job, manpower: 0)).not_to be_valid
      end
    end

    describe '#duration' do
      it 'is not valid without duration' do
        expect(Fabricate.build(:job, duration: nil)).not_to be_valid
      end

      it 'is not valid with a duration of less than 1 hour' do
        expect(Fabricate.build(:job, duration: 0)).not_to be_valid
      end
    end
  end

  describe '#update_status' do
    let(:provider) { Fabricate(:provider) }
    let(:job) { Fabricate.build(:job, manpower: 2, state: 'created', provider: provider) }

    context 'when the job is rated by all participants' do
      it 'sets the state to rated' do
        Fabricate(:allocation, job: job)
        Fabricate(:allocation, job: job)

        Fabricate(:review, job: job, provider: job.provider)
        Fabricate(:review, job: job, seeker: job.seekers.first)
        Fabricate(:review, job: job, seeker: job.seekers.last)

        job.reload.send(:evaluate_state, nil)
        expect(job.reload.state).to eql('rated')
      end
    end

    context 'when the job has the manpower needed assigned' do
      it 'sets the state to connected' do
        Fabricate(:allocation, job: job)
        Fabricate(:allocation, job: job)

        job.reload.send(:evaluate_state, nil)
        expect(job.reload.state).to eql('connected')
      end
    end

    context 'when the job has not enough manpower' do
      it 'sets the state to available' do
        job.send(:evaluate_state, nil)
        expect(job.reload.state).to eql('available')
      end
    end
  end

  describe '#send_job_created' do
    let(:provider) { Fabricate(:provider) }
    let(:job) { Fabricate.build(:job, state: 'created', provider: provider) }
    let(:mailer) { double('mailer') }

    it 'sends an email to the broker when a job is created' do
      expect(Notifier).to receive(:job_created_for_broker).with(job).and_return(mailer)
      expect(mailer).to receive(:deliver)
      job.save
    end
  end

  describe '#send_job_connected' do
    let(:seeker) { Fabricate(:seeker) }
    let(:job) { Fabricate(:job, state: 'available', place: seeker.place, allocations: [seeker]) }
    let(:mailer) { double('mailer') }

    it 'sends an email to the seeker when a job is connected' do
      expect(Notifier).to receive(:job_connected_for_seekers).with(job).and_return(mailer)
      expect(mailer).to receive(:deliver)
      job.update_attributes(state: 'connected')
    end

    it 'sends an email to the provider when a job is connected' do
      expect(Notifier).to receive(:job_connected_for_provider).with(job).and_return(mailer)
      expect(mailer).to receive(:deliver)
      job.update_attributes(state: 'connected')
    end
  end

  describe '.send_rating_reminders' do
    let(:seeker) { Fabricate(:seeker) }
    let(:mailer) { double('mailer') }

    context 'with a job on a specific date' do
      let!(:job) { Fabricate(:job, state: 'connected', place: seeker.place, allocations: [seeker], date_type: 'date', start_date: 2.week.ago) }

      before do
        # Jobs that should not appear
        Fabricate(:job)
        Fabricate(:job, state: 'connected', place: seeker.place, allocations: [seeker], date_type: 'date', start_date: 1.week.ago)
        Fabricate(:job, state: 'connected', place: seeker.place, allocations: [seeker], date_type: 'date', start_date: 2.week.ago, rating_reminder_sent: true)
      end

      it 'sends a reminder to the provider' do
        expect(Notifier).to receive(:job_rating_reminder_for_provider).with(job).and_return(mailer)
        expect(mailer).to receive(:deliver)
        Job.send_rating_reminders
      end

      it 'sends a reminder to the seeker' do
        expect(Notifier).to receive(:job_rating_reminder_for_seekers).with(job).and_return(mailer)
        expect(mailer).to receive(:deliver)
        Job.send_rating_reminders
      end

      it 'remembers that the reminder has been sent' do
        Job.send_rating_reminders
        expect(job.reload.rating_reminder_sent).to be_true
      end
    end

    context 'with a job in a date range' do
      let!(:job) { Fabricate(:job, state: 'connected', place: seeker.place, allocations: [seeker], date_type: 'date_range', start_date: 1.week.ago, end_date: 2.weeks.ago) }

      before do
        # Jobs that should not appear
        Fabricate(:job)
        Fabricate(:job, state: 'connected', place: seeker.place, allocations: [seeker], date_type: 'date_range', start_date: 1.week.ago, end_date: 8.days.ago)
        Fabricate(:job, state: 'connected', place: seeker.place, allocations: [seeker], date_type: 'date_range', start_date: 1.week.ago, end_date: 2.days.ago, rating_reminder_sent: true)
      end

      it 'sends a reminder to the provider' do
        expect(Notifier).to receive(:job_rating_reminder_for_provider).with(job).and_return(mailer)
        expect(mailer).to receive(:deliver)
        Job.send_rating_reminders
      end

      it 'sends a reminder to the seeker' do
        expect(Notifier).to receive(:job_rating_reminder_for_seekers).with(job).and_return(mailer)
        expect(mailer).to receive(:deliver)
        Job.send_rating_reminders
      end

      it 'remembers that the reminder has been sent' do
        Job.send_rating_reminders
        expect(job.reload.rating_reminder_sent).to be_true
      end
    end

    context 'with a job on agreement' do
      let!(:job) { Fabricate(:job, state: 'connected', place: seeker.place, allocations: [seeker], date_type: 'agreement') }

      before do
        job.update_attribute(:updated_at, 2.week.ago)

        # Jobs that should not appear
        Fabricate(:job)
        job_1 = Fabricate(:job, state: 'connected', place: seeker.place, allocations: [seeker], date_type: 'agreement')
        job_1.update_attribute(:updated_at, 1.week.ago)

        job_2 = Fabricate(:job, state: 'connected', place: seeker.place, allocations: [seeker], date_type: 'agreement', rating_reminder_sent: true)
        job_2.update_attribute(:updated_at, 2.week.ago)
      end

      it 'sends a reminder to the provider' do
        expect(Notifier).to receive(:job_rating_reminder_for_provider).with(job).and_return(mailer)
        expect(mailer).to receive(:deliver)
        Job.send_rating_reminders
      end

      it 'sends a reminder to the seeker' do
        expect(Notifier).to receive(:job_rating_reminder_for_seekers).with(job).and_return(mailer)
        expect(mailer).to receive(:deliver)
        Job.send_rating_reminders
      end

      it 'remembers that the reminder has been sent' do
        Job.send_rating_reminders
        expect(job.reload.rating_reminder_sent).to be_true
      end
    end
  end

end
