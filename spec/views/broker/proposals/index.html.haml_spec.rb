require 'spec_helper'

describe 'broker/proposals/index.html.haml' do

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

      context 'list item data' do
        it 'contains the link to edit the proposal details' do
          expect(rendered).to have_link('Seeker A Job A bearbeiten', href: edit_broker_job_proposal_path(job, proposal_A))
          expect(rendered).to have_link('Seeker B Job A bearbeiten', href: edit_broker_job_proposal_path(job, proposal_B))
        end

        it 'contains the link to destroy the proposal' do
          expect(rendered).to have_link('Seeker A Job A löschen', href: broker_job_proposal_path(job, proposal_A))
          expect(rendered).to have_link('Seeker B Job A löschen', href: broker_job_proposal_path(job, proposal_B))
        end
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
      expect(rendered).to have_text('Es sind noch keine Vorschläge für diesen Job erfasst')
    end
  end

  context 'global actions' do
    before do
      assign(:job, job)
      assign(:proposals, [])
      render
    end

    it 'contains the link to add a new proposal' do
      expect(rendered).to have_link('Neuen Vorschlag hinzufügen', new_broker_job_proposal_path(job))
    end

    it 'contains the link to go back to the job' do
      expect(rendered).to have_link('Zurück', broker_job_path(job))
    end
  end
end
