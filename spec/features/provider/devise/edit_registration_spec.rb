# coding: UTF-8

require 'spec_helper'

feature 'Edit registration profile' do

  let(:org) { Fabricate(:org_lenzburg) }
  let(:region) { org.regions.first }

  let(:provider) do
    Fabricate(:provider,
              email: 'rolf@example.com',
              password: 'tester1234',
              password_confirmation: 'tester1234',
              place: region.places.first)
  end

  background do
    login_as(provider, scope: :provider)
  end

  scenario 'Edit the credentials' do
    visit_on region, '/provider/dashboard'

    click_on 'Profil'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Benutzername',        with: 'roberto'
      fill_in 'Passwort',            with: 'tester12345'
      fill_in 'Passwortbestätigung', with: 'tester12345'
    end

    fill_in 'Aktuelles Passwort', with: 'tester1234'
    click_on 'Ändern'

    within_notifications do
      expect(page).to have_content('Ihre Daten wurden aktualisiert.')
    end
  end

  scenario 'Edit the address' do
    visit_on region, '/provider/dashboard'

    click_on 'Profil'

    within_fieldset 'Adresse' do
      fill_in 'Vorname',  with: 'Robi'
      fill_in 'Nachname', with: 'Blanco'
      fill_in 'Strasse',  with: 'Weissstrasse 123'

      select 'Niederlenz', from: 'Ort'
    end

    fill_in 'Aktuelles Passwort', with: 'tester1234'
    click_on 'Ändern'

    within_notifications do
      expect(page).to have_content('Ihre Daten wurden aktualisiert.')
    end
  end

  scenario 'Edit the contact' do
    visit_on region, '/provider/dashboard'
    click_on 'Profil'

    within_fieldset 'Kontakt' do
      fill_in 'Email',   with: 'roberto@example.com'
      fill_in 'Telefon', with: '056 496 03 58'
      fill_in 'Mobil',   with: '079 244 55 61'

      select 'Mobiltelefon', from: 'Bevorzuge Kontaktart'

      fill_in 'Am Besten zu Erreichen', with: 'Abends'
    end

    fill_in 'Aktuelles Passwort', with: 'tester1234'
    click_on 'Ändern'

    within_notifications do
      expect(page).to have_content('Ihre Daten wurden aktualisiert.')
    end
  end
end
