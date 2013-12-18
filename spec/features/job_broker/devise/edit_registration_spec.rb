# coding: UTF-8

require 'spec_helper'

feature 'Edit registration profile' do
  let(:user) do
    Fabricate(:job_broker,
              email: 'rolf@example.com',
              password: 'tester1234',
              password_confirmation: 'tester1234')
  end

  background do
    login_as(user, scope: :job_broker)
  end

  scenario 'Edit the credentials' do
    visit '/job_brokers/dashboard'
    click_on 'Profil'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Email',               with: 'roberto@example.com'
      fill_in 'Passwort',            with: 'tester12345'
      fill_in 'Passwortbestätigung', with: 'tester12345'
    end

    fill_in 'Aktuelles Passwort', with: 'tester1234'
    click_on 'Ändern'

    within_notifications do
      expect(page).to have_content('Ihre Daten wurden aktualisiert, aber Sie müssen Ihre neue E-Mail-Adresse bestätigen.')
    end

    open_email('roberto@example.com')
    current_email.click_link('Konto bestätigen')

    within_notifications do
      expect(page).to have_content('Vielen Dank für Ihre Bestätigung.')
    end
  end

  scenario 'Edit the address' do
    visit '/job_brokers/dashboard'
    click_on 'Profil'

    within_fieldset 'Adresse' do
      fill_in 'Vorname',  with: 'Robi'
      fill_in 'Nachname', with: 'Blanco'
    end

    fill_in 'Aktuelles Passwort', with: 'tester1234'
    click_on 'Ändern'

    within_notifications do
      expect(page).to have_content('Ihre Daten wurden aktualisiert.')
    end
  end

  scenario 'Edit the contact' do
    visit '/job_brokers/dashboard'
    click_on 'Profil'

    within_fieldset 'Kontakt' do
      fill_in 'Telefon', with: '056 496 03 58'
      fill_in 'Mobil',   with: '079 244 55 61'
    end

    fill_in 'Aktuelles Passwort', with: 'tester1234'
    click_on 'Ändern'

    within_notifications do
      expect(page).to have_content('Ihre Daten wurden aktualisiert.')
    end
  end
end
