require 'spec_helper'

describe 'provider/jobs/index.html.haml' do
  let(:provider) { Fabricate(:provider) }

  let(:job_A) { Fabricate(:job, title: 'Job A', provider: provider) }
  let(:job_B) { Fabricate(:job, title: 'Job B', provider: provider) }

  context 'with jobs' do
    before do
      assign(:jobs, [job_A, job_B])
      render
    end

    context 'list items' do
      it 'render the job title' do
        expect(rendered).to have_text('Job A')
        expect(rendered).to have_text('Job B')
      end

      context 'list item data' do
        it 'contains the link to show the jobs details' do
          expect(rendered).to have_link('Job A anzeigen', href: provider_job_path(job_A))
          expect(rendered).to have_link('Job B anzeigen', href: provider_job_path(job_B))
        end

        it 'contains the link to edit the jobs details' do
          expect(rendered).to have_link('Job A bearbeiten', href: edit_provider_job_path(job_A))
          expect(rendered).to have_link('Job B bearbeiten', href: edit_provider_job_path(job_B))
        end

        it 'contains the link to destroy the jobs' do
          expect(rendered).to have_link('Job A löschen', href: provider_job_path(job_A))
          expect(rendered).to have_link('Job B löschen', href: provider_job_path(job_B))
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
      expect(rendered).to have_text('Sie haben noch keine Jobs erfasst')
    end
  end

  context 'global actions' do
    before do
      assign(:jobs, [])
      render
    end

    it 'contains the link to add a new provider' do
      expect(rendered).to have_link('Neuen Job hinzufügen', new_provider_job_path)
    end
  end
end
