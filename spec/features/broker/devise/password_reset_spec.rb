# coding: UTF-8

require 'spec_helper'

feature 'Password reset' do
  context 'with an unconfirmed user' do
    let(:broker) do
      Fabricate(:broker_with_regions,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                confirmed: false,
                active: false)
    end

    scenario 'using valid credentials' do
      visit_on broker, '/'

      click_on 'Anmelden'
      click_on 'Vermittler'
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
        expect(page).to have_content('Sie müssen Ihren Email bestätigen, bevor Sie fortfahren können.')
      end
    end
  end

  context 'with an inactive user' do
    let(:broker) do
      Fabricate(:broker_with_regions,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                confirmed: true,
                active: false)
    end

    scenario 'using valid credentials' do
      visit_on broker, '/'

      click_on 'Anmelden'
      click_on 'Vermittler'
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
    let(:broker) do
      Fabricate(:broker_with_regions,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                confirmed: true,
                active: true)
    end

    scenario 'using invalid email' do
      visit_on broker, '/'

      click_on 'Anmelden'
      click_on 'Vermittler'
      click_on 'Passwort vergessen?'

      fill_in 'Email', with: 'inexistent@example.com'

      click_on 'Passwort zurücksetzen'

      expect(page).to have_content('nicht gefunden')
    end

    scenario 'using valid credentials' do
      visit_on broker, '/'

      click_on 'Anmelden'
      click_on 'Vermittler'
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

      expect(current_path).to eql('/broker/dashboard')
    end
  end
end
