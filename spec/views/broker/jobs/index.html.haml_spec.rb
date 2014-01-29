require 'spec_helper'

describe 'broker/jobs/index.html.haml' do

  let(:job_A) { Fabricate(:job, title: 'Job A', provider: Fabricate(:provider, firstname: 'John', lastname: 'Johnetty')) }
  let(:job_B) { Fabricate(:job, title: 'Job B', provider: Fabricate(:provider, firstname: 'Jasmine', lastname: 'Jassetty')) }

  context 'with providers' do
    before do
      assign(:jobs, [job_A, job_B])
      render
    end

    context 'list items' do
      it 'render the job title' do
        expect(rendered).to have_text('Job A')
        expect(rendered).to have_text('Job B')
      end

      it 'render the provider name' do
        expect(rendered).to have_text('John Johnetty')
        expect(rendered).to have_text('Jasmine Jassetty')
      end

      context 'list item data' do
        it 'contains the link to show the jobs details' do
          expect(rendered).to have_link('Job A anzeigen', href: broker_job_path(job_A))
          expect(rendered).to have_link('Job B anzeigen', href: broker_job_path(job_B))
        end

        it 'contains the link to edit the jobs details' do
          expect(rendered).to have_link('Job A bearbeiten', href: edit_broker_job_path(job_A))
          expect(rendered).to have_link('Job B bearbeiten', href: edit_broker_job_path(job_B))
        end

        it 'contains the link to destroy the jobs' do
          expect(rendered).to have_link('Job A löschen', href: broker_job_path(job_A))
          expect(rendered).to have_link('Job B löschen', href: broker_job_path(job_B))
        end
      end
    end
  end

  context 'without jobs' do
    before do
      assign(:jobs, [])
      render
    end

    it 'shows a message that no jobs are found' do
      expect(rendered).to have_text('Es sind noch keine Jobs in deiner Region erfasst')
    end
  end

  context 'global actions' do
    before do
      assign(:jobs, [])
      render
    end

    it 'contains the link to add a new provider' do
      expect(rendered).to have_link('Neuen Job hinzufügen', new_broker_job_path)
    end
  end
end
