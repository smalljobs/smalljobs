require 'spec_helper'

describe 'provider/allocations/index.html.haml' do

  let(:job) { Fabricate(:job, title: 'Job A') }

  let(:allocation_A) do
    Fabricate(:allocation,
              job: job,
              message: 'Try this',
              seeker: Fabricate(:seeker,
                                firstname: 'Seeker',
                                lastname: 'A',
                                street: 'Vordergasse 21',
                                email: 'a@seeker.com',
                                phone: '044 123 45 67',
                                mobile: '079 123 45 67'))
  end

  let(:allocation_B) do
    Fabricate(:allocation,
              job: job,
              message: 'Another one',
              seeker: Fabricate(:seeker,
                                firstname: 'Seeker',
                                lastname: 'B',
                                street: 'Hintergasse 12',
                                email: 'b@seeker.com',
                                phone: '044 765 43 21',
                                mobile: '079 765 43 21'))
  end

  context 'with allocations' do
    before do
      assign(:job, job)
      assign(:allocations, [allocation_A, allocation_B])
      render
    end

    context 'list items' do
      it 'render the job title' do
        expect(rendered).to have_text('Job A')
      end

      it 'render the seekers name' do
        expect(rendered).to have_text('Seeker A')
        expect(rendered).to have_text('Seeker B')
      end

      it 'render the seekers street' do
        expect(rendered).to have_text('Vordergasse 21')
        expect(rendered).to have_text('Hintergasse 12')
      end

      it 'render the seekers email' do
        expect(rendered).to have_text('a@seeker.com')
        expect(rendered).to have_text('b@seeker.com')
      end

      it 'render the seekers phone' do
        expect(rendered).to have_text('044 123 45 67')
        expect(rendered).to have_text('079 123 45 67')
      end

      it 'render the seekers mobile' do
        expect(rendered).to have_text('044 765 43 21')
        expect(rendered).to have_text('079 765 43 21')
      end
    end
  end

  context 'without allocations' do
    before do
      assign(:job, job)
      assign(:allocations, [])
      render
    end

    it 'shows a message that no allocations are found' do
      expect(rendered).to have_text('Es sind noch keine Zuweisungen für diesen Job erfasst')
    end
  end

  context 'global actions' do
    before do
      assign(:job, job)
      assign(:allocations, [])
      render
    end

    it 'contains the link to go back to the job' do
      expect(rendered).to have_link('Zurück', provider_job_path(job))
    end
  end
end

