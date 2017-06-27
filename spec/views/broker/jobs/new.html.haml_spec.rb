require 'spec_helper'

describe 'broker/jobs/new.html.haml' do

  let(:region) { Fabricate(:region) }
  let(:job) { Fabricate.build(:job) }

  before do
    assign(:job, job)
    view.stub(current_region: region)
    render
  end

  context 'form elements' do
    it 'renders the assignment input' do
      expect(rendered).to have_field('Anbieter')
      expect(rendered).to have_field('Arbeitskategorie')
    end

    it 'renders the job inputs' do
      expect(rendered).to have_field('Titel')
      expect(rendered).to have_field('Beschreibung')
    end

    it 'renders the date inputs' do
      expect(rendered).to have_field('Zeitraum')
      expect(rendered).to have_field('Startdatum')
      expect(rendered).to have_field('Enddatum')
    end

    it 'renders the salary inputs' do
      expect(rendered).to have_field('Art des Lohnes')
      expect(rendered).to have_field('Lohn')
    end

    it 'renders the work inputs' do
      expect(rendered).to have_field('Arbeitskräfte')
      expect(rendered).to have_field('Dauer')
    end

    context 'form actions' do
      it 'renders the create button' do
        expect(rendered).to have_button('Erstellen')
      end
    end
  end

  context 'global actions' do
    it 'contains the link to the jobslist' do
      expect(rendered).to have_link('Zurück', broker_jobs_path)
    end
  end
end
