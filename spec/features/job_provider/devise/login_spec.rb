# coding: UTF-8

require 'spec_helper'

feature 'Login' do
  context 'with an unconfirmed user' do
    context 'without an email' do
      background do
        Fabricate(:job_provider,
                  username: 'rolf',
                  password: 'tester1234',
                  password_confirmation: 'tester1234',
                  confirmed: false,
                  active: false)
      end

      scenario 'using valid credentials' do
        visit '/'
        click_on 'Anmelden'
        click_on 'Anbieter'

        fill_in 'Benutzername', with: 'rolf'
        fill_in 'Passwort',     with: 'tester1234'

        click_on 'Als Jobanbieter anmelden'

        within_notifications do
          expect(page).to have_content('Wir werden Sie in Kürze kontaktieren um ihren Account zu bestätigen.')
        end
      end
    end

    context 'with an email' do
      background do
        Fabricate(:job_provider,
                  email: 'rolf@example.com',
                  username: 'rolf',
                  password: 'tester1234',
                  password_confirmation: 'tester1234',
                  confirmed: false,
                  active: false)
      end

      scenario 'using valid credentials' do
        visit '/'
        click_on 'Anmelden'
        click_on 'Anbieter'

        fill_in 'Benutzername', with: 'rolf'
        fill_in 'Passwort',     with: 'tester1234'

        click_on 'Als Jobanbieter anmelden'

        within_notifications do
          expect(page).to have_content('Sie müssen Ihren Account bestätigen, bevor Sie fortfahren können.')
        end
      end
    end
  end

  context 'with an inactive user' do
    background do
      Fabricate(:job_provider,
                email: 'rolf@example.com',
                username: 'rolf',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                confirmed: true,
                active: false)
    end

    scenario 'using valid credentials' do
      visit '/'
      click_on 'Anmelden'
      click_on 'Anbieter'

      fill_in 'Benutzername', with: 'rolf'
      fill_in 'Passwort',     with: 'tester1234'

      click_on 'Als Jobanbieter anmelden'

      within_notifications do
        expect(page).to have_content('Ihr Account ist nicht aktiv')
      end
    end
  end

  context 'with an active user' do
    background do
      Fabricate(:job_provider,
                email: 'rolf@example.com',
                username: 'rolf',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                confirmed: true,
                active: true)
    end

    scenario 'using invalid credentials' do
      visit '/'
      click_on 'Anmelden'
      click_on 'Anbieter'

      fill_in 'Benutzername', with: 'dani'
      fill_in 'Passwort',     with: 'tester'

      click_on 'Als Jobanbieter anmelden'

      within_notifications do
        expect(page).to have_content('Ungültige Anmeldedaten')
      end
    end

    scenario 'using valid credentials' do
      visit '/'
      click_on 'Anmelden'
      click_on 'Anbieter'

      fill_in 'Benutzername', with: 'rolf'
      fill_in 'Passwort',     with: 'tester1234'

      click_on 'Als Jobanbieter anmelden'

      within_notifications do
        expect(page).to have_content('Erfolgreich angemeldet')
      end

      expect(current_path).to eql('/job_providers/dashboard')
    end
  end
end
