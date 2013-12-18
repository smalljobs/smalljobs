# coding: UTF-8

require 'spec_helper'

feature 'New job broker registration' do
  scenario 'public registrations' do
    visit '/job_brokers/sign_up'

    within_notifications do
      expect(page).to have_content('Sie können sich nicht selber als Anbieter registrieren. Bitte kontaktieren Sie uns unter hello@smalljobs.ch')
    end

    expect(current_path).to eql('/')
  end

  context 'from the admin backend' do
    let(:admin) { Fabricate(:admin) }

    background do
      login_as(admin, scope: :admin)
    end

    scenario 'invites a new job broker' do
      visit '/admin'
      click_on 'Vermittler'
      click_on 'Neu hinzufügen'

      within_fieldset 'Authentifizierung' do
        fill_in 'Email', with: 'rolf@example.com'
        fill_in 'Passwort', with: 'tester1234'
      end

      within_fieldset 'Kontakt' do
        fill_in 'Vorname', with: 'Rolf'
        fill_in 'Nachname', with: 'Radieschen'
        fill_in 'Telefon', with: '044 444 44 44'
        fill_in 'Mobile', with: '079 333 33 33'
      end

      click_on 'Speichern'

      open_email('rolf@example.com')
      current_email.click_link 'Email bestätigen'

      within_notifications do
        expect(page).to have_content('Vielen Dank für Ihre Bestätigung.')
      end
    end
  end

end
