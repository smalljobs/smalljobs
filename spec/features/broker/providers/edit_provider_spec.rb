# coding: UTF-8

require 'spec_helper'

feature 'Edit a provider' do
  let(:broker) do
    Fabricate(:broker_with_regions)
  end

  background do
    Fabricate(:provider, {
      firstname: 'Dora',
      lastname: 'Doretty',
      place: broker.places.first
    })

    login_as(broker, scope: :broker)
  end

  scenario 'updates the provider data' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Anbieter anzeigen'
    click_on 'Dora Doretty bearbeiten'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Benutzername',        with: 'meier'
      fill_in 'Passwort',            with: 'chicksonspeed'
      fill_in 'Passwortbestätigung', with: 'chicksonspeed'
    end

    within_fieldset 'Adresse' do
      fill_in 'Vorname',  with: 'Rolf'
      fill_in 'Nachname', with: 'Meier'
      fill_in 'Strasse',  with: 'Hühnerstall 12'

      select 'Vessy', from: 'Ort'
    end

    within_fieldset 'Kontakt' do
      fill_in 'Email',   with: 'meier@example.com'
      fill_in 'Telefon', with: '+41 044 444 44 44'
      fill_in 'Mobile',  with: '+41 079 444 44 44'
    end

    click_on 'Bearbeiten'

    within_notifications do
      expect(page).to have_content('Anbieter wurde erfolgreich aktualisiert.')
    end
  end

 end
