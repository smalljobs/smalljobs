# coding: UTF-8

require 'spec_helper'

feature 'Login' do
  context 'with an unconfirmed user' do
    background do
      Fabricate(:job_broker,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                confirmed: false,
                active: false)
    end

    scenario 'using valid credentials' do
      visit '/'
      click_on 'Anmelden'
      click_on 'Vermittler'

      fill_in 'Email',    with: 'rolf@example.com'
      fill_in 'Passwort', with: 'tester1234'

      click_on 'Als Jobvermittler anmelden'

      within_notifications do
        expect(page).to have_content('Sie müssen Ihren Email bestätigen, bevor Sie fortfahren können.')
      end
    end
  end

  context 'with an inactive user' do
    background do
      Fabricate(:job_broker,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                confirmed: true,
                active: false)
    end

    scenario 'using valid credentials' do
      visit '/'
      click_on 'Anmelden'
      click_on 'Vermittler'

      fill_in 'Email',    with: 'rolf@example.com'
      fill_in 'Passwort', with: 'tester1234'

      click_on 'Als Jobvermittler anmelden'

      within_notifications do
        expect(page).to have_content('Ihr Konto ist nicht aktiv')
      end
    end
  end

  context 'with an active user' do
    background do
      Fabricate(:job_broker,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                confirmed: true,
                active: true)
    end

    scenario 'using invalid credentials' do
      visit '/'
      click_on 'Anmelden'
      click_on 'Vermittler'

      fill_in 'Email',    with: 'dani@example.com'
      fill_in 'Passwort', with: 'tester'

      click_on 'Als Jobvermittler anmelden'

      within_notifications do
        expect(page).to have_content('Ungültige Anmeldedaten')
      end
    end

    scenario 'using valid credentials' do
      visit '/'
      click_on 'Anmelden'
      click_on 'Vermittler'

      fill_in 'Email',    with: 'rolf@example.com'
      fill_in 'Passwort', with: 'tester1234'

      click_on 'Als Jobvermittler anmelden'

      within_notifications do
        expect(page).to have_content('Erfolgreich angemeldet')
      end

      expect(current_path).to eql('/broker/dashboard')
    end
  end
end
