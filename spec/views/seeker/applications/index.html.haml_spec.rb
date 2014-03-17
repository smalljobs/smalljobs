require 'spec_helper'

describe 'seeker/applications/index.html.haml' do

  let(:job) { Fabricate(:job, title: 'Job A') }

  let(:seeker) { Fabricate(:seeker, firstname: 'Seeker', lastname: 'A') }

  let(:application) { Fabricate(:application, job: job, message: 'Try this', seeker: seeker) }

  context 'with jobs' do
    before do
      assign(:job, job)
      assign(:applications, [application])
      render
    end

    context 'list items' do
      it 'render the job title' do
        expect(rendered).to have_text('Job A')
      end

      it 'render the application message name' do
        expect(rendered).to have_text('Try this')
      end

      context 'list item data' do
        it 'contains the link to edit the application details' do
          expect(rendered).to have_link('Seeker A Job A bearbeiten', href: edit_seeker_job_application_path(job, application))
        end

        it 'contains the link to destroy the application' do
          expect(rendered).to have_link('Seeker A Job A löschen', href: seeker_job_application_path(job, application))
        end
      end
    end
  end

  context 'without applications' do
    before do
      assign(:job, job)
      assign(:applications, [])
      render
    end

    it 'shows a message that no applications are found' do
      expect(rendered).to have_text('Du hast dich für diesen Job noch nicht beworben')
    end

    it 'contains the link to go back to the job' do
      expect(rendered).to have_link('Zurück', seeker_job_path(job))
    end
  end

end
