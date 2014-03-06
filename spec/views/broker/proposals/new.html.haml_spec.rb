require 'spec_helper'

describe 'broker/proposals/new.html.haml' do

  let(:region) { Fabricate(:region) }
  let(:job) { Fabricate(:job) }
  let(:proposal) { Fabricate.build(:proposal) }

  before do
    assign(:job, job)
    assign(:proposal, proposal)
    view.stub(current_region: region)
    render
  end

  context 'form elements' do
    it 'renders the proposal input' do
      expect(rendered).to have_field('Jugendlicher')
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
      expect(rendered).to have_link('Zurück', broker_job_path(job))
    end
  end
end
