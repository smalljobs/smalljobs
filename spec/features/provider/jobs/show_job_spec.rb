# coding: UTF-8

require 'spec_helper'

feature 'Show a job' do
  let(:provider) { Fabricate(:provider_with_region, firstname: 'Roberto', lastname: 'Blanco', street: 'Hubacker 12') }
  let(:place) { provider.place }
  let(:work_category) { Fabricate(:work_category, name: 'Garten') }

  background do
    Fabricate(:provider, place: place, firstname: 'Lisbet', lastname: 'Lesbos')

    Fabricate.times(3, :seeker, place: place)
    Fabricate(:seeker, firstname: 'Susi', lastname: 'Sucher', place: place)

    Fabricate(:work_category, name: 'Tiere')
    Fabricate(:work_category, name: 'Computer')

    Fabricate(:job,
              provider: provider,
              work_category: work_category,
              title: 'Hunde gassi gehen',
              description: 'Habe 25 hunde due am Wochenende raus müssen',
              date_type: 'agreement',
              salary_type: 'hourly',
              salary: 15,
              manpower: 2,
              duration: 30)

    login_as(provider, scope: :provider)
  end

  scenario 'displays all the job details' do
    visit_on provider, '/provider/dashboard'

    click_on 'Alle ihre Jobs anzeigen'
    click_on 'Hunde gassi gehen anzeigen'

    expect(page).to have_content('Roberto Blanco')
    expect(page).to have_content('Hubacker 12')
    expect(page).to have_content('Garten')
    expect(page).to have_content('Hunde gassi gehen')
    expect(page).to have_content('Habe 25 hunde due am Wochenende raus müssen')
    expect(page).to have_content('Nach Absprache')
    expect(page).to have_content('Stundenlohn')
    expect(page).to have_content('CHF 15.00')
    expect(page).to have_content('Benötigte Arbeitskräfte: 2')
    expect(page).to have_content('Ungefähre Dauer: 30 Minuten')
  end

end
