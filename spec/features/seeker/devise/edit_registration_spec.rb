# coding: UTF-8

require 'spec_helper'

feature 'Edit registration profile' do
  let(:region) { Fabricate(:region, name: 'Bremgarten') }

  let(:seeker) do
    Fabricate(:seeker,
              email: 'rolf@example.com',
              password: 'tester1234',
              password_confirmation: 'tester1234')
  end

  background do
    Fabricate(:work_category, name: 'Garten')
    Fabricate(:work_category, name: 'Tiere')
    Fabricate(:work_category, name: 'Computer')

    login_as(seeker, scope: :seeker)
  end

  scenario 'Edit the credentials' do
    visit_on region, '/seeker/dashboard'

    click_on 'Profil'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Email',   with: 'roberto@example.com'
      fill_in 'Passwort',            with: 'tester12345'
      fill_in 'Passwortbestätigung', with: 'tester12345'
    end

    fill_in 'Aktuelles Passwort', with: 'tester1234'
    click_on 'Ändern'

    within_notifications do
      expect(page).to have_content('Ihre Daten wurden aktualisiert, aber Sie müssen Ihre neue E-Mail-Adresse bestätigen.')
    end

    open_email('roberto@example.com')
    current_email.click_link('Email bestätigen')

    within_notifications do
      expect(page).to have_content('Vielen Dank für Ihre Bestätigung.')
    end
  end

  scenario 'Edit the address' do
    visit_on region, '/seeker/dashboard'

    click_on 'Profil'

    within_fieldset 'Adresse' do
      fill_in 'Vorname',  with: 'Robi'
      fill_in 'Nachname', with: 'Blanco'
      fill_in 'Strasse',  with: 'Weissstrasse 123'
      fill_in 'PLZ',      with: '5432'
      fill_in 'Ort',      with: 'Testwil'
    end

    fill_in 'Aktuelles Passwort', with: 'tester1234'
    click_on 'Ändern'

    within_notifications do
      expect(page).to have_content('Ihre Daten wurden aktualisiert.')
    end
  end

  scenario 'Edit the contact' do
    visit_on region, '/seeker/dashboard'

    click_on 'Profil'

    within_fieldset 'Kontakt' do
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

  scenario 'Edit the works' do
    visit_on region, '/seeker/dashboard'

    click_on 'Profil'

    within_fieldset 'Arbeit' do
      check 'Garten'
      check 'Tiere'
    end

    fill_in 'Aktuelles Passwort', with: 'tester1234'
    click_on 'Ändern'

    within_notifications do
      expect(page).to have_content('Ihre Daten wurden aktualisiert.')
    end
  end
end
