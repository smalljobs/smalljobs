# coding: UTF-8

require 'spec_helper'

feature 'Add a new job' do
  let(:provider) { Fabricate(:provider) }
  let(:place) { provider.place }

  background do
    Fabricate(:provider, place: place, firstname: 'Roberto', lastname: 'Blanco')
    Fabricate(:provider, place: place, firstname: 'Lisbet', lastname: 'Lesbos')

    Fabricate.times(3, :seeker)

    Fabricate(:work_category, name: 'Garten')
    Fabricate(:work_category, name: 'Tiere')
    Fabricate(:work_category, name: 'Computer')

    login_as(provider, scope: :provider)
  end

  scenario 'with valid data' do
    visit_on provider, '/provider/dashboard'

    click_on 'Alle ihre Jobs anzeigen'
    click_on 'Neuen Job hinzufügen'

    within_fieldset 'Job' do
      select 'Tiere',         from: 'Arbeitskategorie'
      fill_in 'Titel',        with: 'Hunde gassi gehen'
      fill_in 'Beschreibung', with: 'Habe 25 Hunde die am Wochenende raus müssen'
    end

    within_fieldset 'Zeitraum' do
      select 'Nach Absprache', from: 'Zeitraum'
    end

    within_fieldset 'Bezahlung' do
      select 'Stundenlohn', from: 'Art des Lohnes'
      fill_in 'Lohn', with: '15'
    end

    within_fieldset 'Arbeit' do
      fill_in 'Arbeitskräfte', with: '2'
      fill_in 'Dauer', with: '60'
    end

    click_on 'Erstellen'

    within_notifications do
      expect(page).to have_content('Job wurde erfolgreich erstellt.')
    end
  end

end
