# coding: UTF-8

require 'spec_helper'

feature 'Show a job' do
  let(:organization) { Fabricate(:org_lenzburg) }
  let(:region) { organization.regions.first }
  let(:place) { region.places.first }

  let(:provider_1) { Fabricate(:provider, firstname: 'Mada', lastname: 'Makowski', street: 'Im Rau 2', place: place )}
  let(:provider_2) { Fabricate(:provider, firstname: 'Rolf', lastname: 'Gümmeli', street: 'Am Eg 1a', place: place )}

  background do
    Fabricate(:job, title: 'Job 1', salary: 12, provider: provider_1)
    Fabricate(:job, title: 'Job 2', salary: 14, provider: provider_2)
  end

  scenario 'shows the region jobs details' do
    visit_on region, '/'

    expect(page).to have_text('Job 1')
    expect(page).to have_text('Job 2')

    click_on 'Job Job 1 anzeigen'

    expect(page).to have_text('Job 1')
    expect(page).to_not have_text('Job 2')

    click_on 'Zurück zur Region Lenzburg'
    click_on 'Job Job 2 anzeigen'

    expect(page).to_not have_text('Job 1')
    expect(page).to have_text('Job 2')

    click_on 'Zurück zur Region Lenzburg'
  end

end
