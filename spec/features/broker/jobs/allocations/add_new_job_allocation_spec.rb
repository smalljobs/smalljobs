# coding: UTF-8

require 'spec_helper'

feature 'Add a new job allocation' do
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

    click_on 'Zuweisungen'
    click_on 'Neue Zuweisung hinzufügen'

    within_fieldset 'Zuweisung' do
      select 'Roberto Blanco', from: 'Jugendlicher'
      fill_in 'Nachricht', with: 'Das wäre doch etwas für dich'
    end

    click_on 'Erstellen'

    within_notifications do
      expect(page).to have_content('Zuweisung wurde erfolgreich erstellt.')
    end
  end

end
