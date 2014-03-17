require 'spec_helper'

describe 'broker/applications/index.html.haml' do

  let(:job) { Fabricate(:job, title: 'Job A') }

  let(:application_A) { Fabricate(:application, job: job, message: 'Try this', seeker: Fabricate(:seeker, firstname: 'Seeker', lastname: 'A')) }
  let(:application_B) { Fabricate(:application, job: job, message: 'Another one', seeker: Fabricate(:seeker, firstname: 'Seeker', lastname: 'B')) }

  context 'with jobs' do
    before do
      assign(:job, job)
      assign(:applications, [application_A, application_B])
      render
    end

    context 'list items' do
      it 'render the job title' do
        expect(rendered).to have_text('Job A')
      end

      it 'render the application message name' do
        expect(rendered).to have_text('Try this')
        expect(rendered).to have_text('Another one')
      end

      it 'render the seekers name' do
        expect(rendered).to have_text('Seeker A')
        expect(rendered).to have_text('Seeker B')
      end

      context 'list item data' do
        it 'contains the link to edit the application details' do
          expect(rendered).to have_link('Seeker A Job A bearbeiten', href: edit_broker_job_application_path(job, application_A))
          expect(rendered).to have_link('Seeker B Job A bearbeiten', href: edit_broker_job_application_path(job, application_B))
        end

        it 'contains the link to destroy the application' do
          expect(rendered).to have_link('Seeker A Job A löschen', href: broker_job_application_path(job, application_A))
          expect(rendered).to have_link('Seeker B Job A löschen', href: broker_job_application_path(job, application_B))
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
      expect(rendered).to have_text('Es sind noch keine Bewerbungen für diesen Job eingegangen')
    end
  end

end
