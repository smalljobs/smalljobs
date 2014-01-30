require 'spec_helper'

describe 'regions/show.html.haml' do

  let(:organization) { Fabricate(:org_lenzburg) }

  let(:place_1) { Fabricate(:place, zip: '1234', name: 'Süliswil') }
  let(:place_2) { Fabricate(:place, zip: '5432', name: 'Saubode') }

  let(:provider_1) { Fabricate(:provider, firstname: 'Mada', lastname: 'Makowski', street: 'Im Rau 2', place: place_1 )}
  let(:provider_2) { Fabricate(:provider, firstname: 'Rolf', lastname: 'Gümmeli', street: 'Am Eg 1a', place: place_2 )}

  let(:job_1) { Fabricate(:job, title: 'Job 1', salary: 12, provider: provider_1) }
  let(:job_2) { Fabricate(:job, title: 'Job 2', salary: 14, provider: provider_2) }

  before do
    assign(:jobs, [job_1, job_2])
    assign(:organization, organization)
  end

  context 'without organization images' do
    before do
      render
    end

    it 'shows the organization name' do
      expect(rendered).to have_text('Jugendarbeit Lenzburg')
    end

    it 'shows the organization description' do
      expect(rendered).to have_text('regionale Jugendarbeit Lotten')
    end

    it 'shows the organization address' do
      expect(rendered).to have_text('c/o JA Lenzburg, Soziale Dienste')
      expect(rendered).to have_text('5600 Lenzburg')
    end

    it 'shows the organization contact info' do
      expect(rendered).to have_text('062 508 13 14')
      expect(rendered).to have_text('info@jugendarbeit-lotten.ch')
      expect(rendered).to have_text('www.jugendarbeit-lotten.ch')
    end

    it 'shows the organization places' do
      expect(rendered).to have_text('Niederlenz')
      expect(rendered).to have_text('Boniswil')
      expect(rendered).to have_text('Egliswil')
      expect(rendered).to have_text('Seon')
    end

    it 'shows the organization brokers' do
      expect(rendered).to have_text('Mich Wyser')
      expect(rendered).to have_text('062 897 01 21')
    end
  end

  context 'with a background image' do

    let(:logo) { double('logo', present?: true, url: 'http://bucket.s3.amazon.com/logo.png') }
    let(:background) { double('background', present?: true, url: 'http://bucket.s3.amazon.com/background.png') }

    before do
      organization.stub(logo: logo, background: background)
      render
    end

    it 'adds the logo image' do
      expect(rendered).to include('background-image: url(http://bucket.s3.amazon.com/background.png)')
    end

    it 'adds the background image' do
      expect(rendered).to have_css('img[src="http://bucket.s3.amazon.com/logo.png"]')
    end
  end

  context 'for the jobs' do
    before do
      render
    end

    it 'renders the job titles' do
      expect(rendered).to have_text('Job 1')
      expect(rendered).to have_text('Job 1')
    end

    it 'renders the job salaries' do
      expect(rendered).to have_text('CHF 12')
      expect(rendered).to have_text('CHF 14')
    end

    it 'renders the provider name' do
      expect(rendered).to have_text('Mada Makowski')
      expect(rendered).to have_text('Rolf Gümmeli')
    end

    it 'renders the provider place' do
      expect(rendered).to have_text('1234 Süliswil')
      expect(rendered).to have_text('5432 Saubode')
    end

    it 'renders the links to the jobs' do
      expect(rendered).to have_link('Job anzeigen', job_path(job_1))
      expect(rendered).to have_link('Job anzeigen', job_path(job_2))
    end
  end
end
