# coding: UTF-8

require 'spec_helper'

feature 'Add a new job' do
  let(:broker) { Fabricate(:broker_with_regions) }
  let(:place) { broker.regions.first.places.first }

  background do
    Fabricate(:provider, place: place, firstname: 'Roberto', lastname: 'Blanco')
    Fabricate(:provider, place: place, firstname: 'Lisbet', lastname: 'Lesbos')

    Fabricate.times(3, :seeker)

    Fabricate(:work_category, name: 'Garten')
    Fabricate(:work_category, name: 'Tiere')
    Fabricate(:work_category, name: 'Computer')

    login_as(broker, scope: :broker)
  end

  scenario 'with valid data' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'
    click_on 'Neuen Job hinzufügen'

    within_fieldset 'Zuweisungen' do
      select 'Lisbet Lesbos', from: 'Anbieter'
      select 'Tiere',         from: 'Arbeitskategorie'
    end

    within_fieldset 'Job' do
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
