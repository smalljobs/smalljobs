require 'spec_helper'

describe 'seeker/applications/new.html.haml' do

  let(:region) { Fabricate(:region) }
  let(:job) { Fabricate(:job) }
  let(:application) { Fabricate.build(:application) }

  before do
    assign(:job, job)
    assign(:application, application)

    view.stub(current_seeker: Fabricate(:seeker))
    view.stub(current_region: region)
    render
  end

  context 'form elements' do
    it 'renders the application input' do
      expect(rendered).to have_field('Job')
      expect(rendered).to have_field('Nachricht')
    end

    context 'form actions' do
      it 'renders the create button' do
        expect(rendered).to have_button('Erstellen')
      end
    end
  end

  context 'global actions' do
    it 'contains the link to the job' do
      expect(rendered).to have_link('Zurück', provider_job_path(job))
    end
  end
end
