require 'spec_helper'

describe 'seeker/proposals/index.html.haml' do

  let(:job) { Fabricate(:job, title: 'Job A') }

  let(:proposal_A) { Fabricate(:proposal, job: job, message: 'Try this', seeker: Fabricate(:seeker, firstname: 'Seeker', lastname: 'A')) }
  let(:proposal_B) { Fabricate(:proposal, job: job, message: 'Another one', seeker: Fabricate(:seeker, firstname: 'Seeker', lastname: 'B')) }

  context 'with jobs' do
    before do
      assign(:job, job)
      assign(:proposals, [proposal_A, proposal_B])
      render
    end

    context 'list items' do
      it 'render the job title' do
        expect(rendered).to have_text('Job A')
      end

      it 'render the proposal message name' do
        expect(rendered).to have_text('Try this')
        expect(rendered).to have_text('Another one')
      end

      it 'render the seekers name' do
        expect(rendered).to have_text('Seeker A')
        expect(rendered).to have_text('Seeker B')
      end

    end
  end

  context 'without proposals' do
    before do
      assign(:job, job)
      assign(:proposals, [])
      render
    end

    it 'shows a message that no proposals are found' do
      expect(rendered).to have_text('Es sind noch keine Vorschläge für diesen Job eingegangen')
    end
  end

  context 'global actions' do
    before do
      assign(:job, job)
      assign(:proposals, [])
      render
    end

    it 'contains the link to go back to the job' do
      expect(rendered).to have_link('Zurück', seeker_job_path(job))
    end
  end
end
