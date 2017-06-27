require 'spec_helper'

describe 'broker/allocations/index.html.haml' do

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

      context 'list item data' do
        it 'contains the link to edit the allocation details' do
          expect(rendered).to have_link('Seeker A Job A bearbeiten', href: edit_broker_job_allocation_path(job, allocation_A))
          expect(rendered).to have_link('Seeker B Job A bearbeiten', href: edit_broker_job_allocation_path(job, allocation_B))
        end

        it 'contains the link to destroy the allocation' do
          expect(rendered).to have_link('Seeker A Job A löschen', href: broker_job_allocation_path(job, allocation_A))
          expect(rendered).to have_link('Seeker B Job A löschen', href: broker_job_allocation_path(job, allocation_B))
        end
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

    it 'contains the link to add a new allocation' do
      expect(rendered).to have_link('Neue Zuweisung hinzufügen', new_broker_job_allocation_path(job))
    end

    it 'contains the link to go back to the job' do
      expect(rendered).to have_link('Zurück', broker_job_path(job))
    end
  end
end
