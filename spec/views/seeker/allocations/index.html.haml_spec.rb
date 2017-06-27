require 'spec_helper'

describe 'seeker/allocations/index.html.haml' do

  let(:job) { Fabricate(:job, title: 'Job A') }

  let(:allocation_A) { Fabricate(:allocation, job: job, message: 'Try this', seeker: Fabricate(:seeker, firstname: 'Seeker', lastname: 'A')) }
  let(:allocation_B) { Fabricate(:allocation, job: job, message: 'Another one', seeker: Fabricate(:seeker, firstname: 'Seeker', lastname: 'B')) }

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

      it 'render the allocation message name' do
        expect(rendered).to have_text('Try this')
        expect(rendered).to have_text('Another one')
      end

      it 'render the seekers name' do
        expect(rendered).to have_text('Seeker A')
        expect(rendered).to have_text('Seeker B')
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
      expect(rendered).to have_link('Zurück', seeker_job_path(job))
    end
  end
end
