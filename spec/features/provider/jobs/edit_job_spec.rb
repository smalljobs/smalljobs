# coding: UTF-8

require 'spec_helper'

feature 'Edit a job' do
  let(:provider) { Fabricate(:provider) }
  let(:place) { provider.place }
  let(:work_category) { Fabricate(:work_category, name: 'Garten') }

  background do
    Fabricate(:provider, place: place, firstname: 'Lisbet', lastname: 'Lesbos')

    Fabricate.times(3, :seeker, place: place)
    Fabricate(:seeker, firstname: 'Susanna-Maria', lastname: 'Sucher', place: place)

    Fabricate(:work_category, name: 'Tiere')
    Fabricate(:work_category, name: 'Computer')

    Fabricate(:job,
              provider: provider,
              work_category: work_category,
              title: 'Hunde gassi gehen',
              short_description: 'Habe 25 hunde due am Wochenende raus müssen',
              long_description: 'Habe 25 hunde due am Wochenende raus müssen',
              date_type: 'agreement',
              salary_type: 'hourly',
              salary: 15,
              manpower: 2,
              duration: 30)

    login_as(provider, scope: :provider)
  end

  scenario 'with valid data' do
    visit_on provider, '/provider/dashboard'

    click_on 'Alle ihre Jobs anzeigen'
    click_on 'Hunde gassi gehen bearbeiten'

    within_fieldset 'Job' do
      fill_in 'Titel', with: 'Hunde spazieren gehen'
    end

    within_fieldset 'Bezahlung' do
      fill_in 'Lohn', with: '8'
    end

    within_fieldset 'Arbeit' do
      fill_in 'Arbeitskräfte', with: '1'
    end

    click_on 'Bearbeiten'

    within_notifications do
      expect(page).to have_content('Job wurde erfolgreich aktualisiert.')
    end
  end

end
