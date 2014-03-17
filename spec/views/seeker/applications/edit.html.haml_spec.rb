require 'spec_helper'

describe 'seeker/applications/edit.html.haml' do

  let(:region) { Fabricate(:region) }
  let(:job) { Fabricate(:job) }
  let(:application) { Fabricate(:application) }

  before do
    assign(:job, job)
    assign(:application, application)
    view.stub(current_region: region)
    render
  end

  context 'form elements' do
    it 'renders the application input' do
      expect(rendered).to have_field('Job')
      expect(rendered).to have_field('Nachricht')
    end

    context 'form actions' do
      it 'renders the edit button' do
        expect(rendered).to have_button('Bearbeiten')
      end
    end
  end

  context 'global actions' do
    it 'contains the link to the job' do
      expect(rendered).to have_link('Zurück', seeker_job_path(job))
    end
  end
end
