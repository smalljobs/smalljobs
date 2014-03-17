# coding: UTF-8

require 'spec_helper'

feature 'Add a new job review' do
  let(:broker) { Fabricate(:broker_with_regions) }

  background do
    Fabricate(:job, {
      provider: Fabricate(:provider, {
        firstname: 'John',
        lastname: 'Johnetty' }),
      place: broker.places.first,
      title: 'Job 1'
    })

    Fabricate(:seeker, place: broker.places.first, firstname: 'Roberto', lastname: 'Blanco')

    login_as(broker, scope: :broker)
  end

  scenario 'with valid data' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'
    click_on 'Job 1 anzeigen'

    click_on 'Bewertungen'
    click_on 'Neue Bewertung hinzufügen'

    within_fieldset 'Bewertung' do
      select 'Roberto Blanco', from: 'Jugendlicher'
      select '5', from: 'Bewertung'
      fill_in 'Nachricht', with: 'Das wäre doch etwas für dich'
    end

    click_on 'Erstellen'

    within_notifications do
      expect(page).to have_content('Bewertung wurde erfolgreich erstellt.')
    end
  end

end
