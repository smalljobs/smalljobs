# coding: UTF-8

require 'spec_helper'

feature 'Password reset' do

  let(:org) { Fabricate(:org_lenzburg) }
  let(:region) { org.regions.first }

  context 'with an unconfirmed user' do
    background do
      Fabricate(:provider,
                email: 'rolf@example.com',
                username: 'rolf',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                place: region.places.first,
                confirmed: false,
                active: false)
    end

    scenario 'using valid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Anbieter'
      click_on 'Passwort vergessen?'

      fill_in 'Email', with: 'rolf@example.com'

      click_on 'Passwort zurücksetzen'

      within_notifications do
        expect(page).to have_content('Sie erhalten in wenigen Minuten eine E-Mail mit der Anleitung, wie Sie Ihr Passwort zurücksetzen können.')
      end

      open_email('rolf@example.com')
      current_email.click_link 'Passwort ändern'

      fill_in 'Neues Passwort',       with: 'another1234'
      fill_in 'Passwort wiederholen', with: 'another1234'

      click_on 'Passwort ändern'

      within_notifications do
        expect(page).to have_content('Ihr Passwort wurde geändert.')
        expect(page).to have_content('Sie müssen Ihre Email bestätigen, bevor Sie fortfahren können.')
      end
    end
  end

  context 'with an inactive user' do
    background do
      Fabricate(:provider,
                email: 'rolf@example.com',
                username: 'rolf',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                place: region.places.first,
                confirmed: true,
                active: false)
    end

    scenario 'using valid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Anbieter'
      click_on 'Passwort vergessen?'

      fill_in 'Email', with: 'rolf@example.com'

      click_on 'Passwort zurücksetzen'

      within_notifications do
        expect(page).to have_content('Sie erhalten in wenigen Minuten eine E-Mail mit der Anleitung, wie Sie Ihr Passwort zurücksetzen können.')
      end

      open_email('rolf@example.com')
      current_email.click_link 'Passwort ändern'

      fill_in 'Neues Passwort',       with: 'another1234'
      fill_in 'Passwort wiederholen', with: 'another1234'

      click_on 'Passwort ändern'

      within_notifications do
        expect(page).to have_content('Ihr Passwort wurde geändert.')
        expect(page).to have_content('Ihr Konto ist nicht aktiv.')
      end
    end
  end

  context 'with an active user' do
    background do
      Fabricate(:provider,
                email: 'rolf@example.com',
                username: 'rolf',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                place: region.places.first,
                confirmed: true,
                active: true)
    end

    scenario 'using invalid email' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Anbieter'
      click_on 'Passwort vergessen?'

      fill_in 'Email', with: 'inexistent@example.com'

      click_on 'Passwort zurücksetzen'

      expect(page).to have_content('nicht gefunden')
    end

    scenario 'using valid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Anbieter'
      click_on 'Passwort vergessen?'

      fill_in 'Email', with: 'rolf@example.com'

      click_on 'Passwort zurücksetzen'

      within_notifications do
        expect(page).to have_content('Sie erhalten in wenigen Minuten eine E-Mail mit der Anleitung, wie Sie Ihr Passwort zurücksetzen können.')
      end

      open_email('rolf@example.com')
      current_email.click_link 'Passwort ändern'

      fill_in 'Neues Passwort',       with: 'another1234'
      fill_in 'Passwort wiederholen', with: 'another1234'

      click_on 'Passwort ändern'

      within_notifications do
        expect(page).to have_content('Ihr Passwort wurde geändert. Sie sind jetzt angemeldet.')
      end

      expect(current_path).to eql('/provider/dashboard')
    end
  end
end
