
# coding: UTF-8

require 'spec_helper'

feature 'Activate a job' do
  let(:broker) { Fabricate(:broker_with_regions) }
  let(:place) { broker.regions.first.places.first }
  let(:provider) { Fabricate(:provider, place: place, firstname: 'Roberto', lastname: 'Blanco') }
  let(:work_category) { Fabricate(:work_category, name: 'Garten') }

  background do
    Fabricate(:provider, place: place, firstname: 'Lisbet', lastname: 'Lesbos')

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

    login_as(broker, scope: :broker)
  end

  scenario 'with valid data' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'
    click_on 'Hunde gassi gehen anzeigen'

    expect(page).to have_content 'Erstellt'

    click_on 'Freischalten'

    within_notifications do
      expect(page).to have_content('Job wurde erfolgreich aktiviert.')
    end

    expect(page).to have_content 'Verfügbar'
  end

end
