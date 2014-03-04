# coding: UTF-8

require 'spec_helper'

feature 'Login' do

  let(:org) { Fabricate(:org_lenzburg) }
  let(:region) { org.regions.first }

  context 'with an unconfirmed user' do
    context 'without an email' do
      background do
        Fabricate(:provider,
                  username: 'rolf',
                  email: nil,
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

        fill_in 'Benutzername', with: 'rolf'
        fill_in 'Passwort',     with: 'tester1234'

        click_on 'Als Anbieter anmelden'

        within_notifications do
          expect(page).to have_content('Wir werden Sie in Kürze kontaktieren um ihr Konto zu bestätigen.')
        end
      end
    end

    context 'with an email' do
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

        fill_in 'Benutzername', with: 'rolf'
        fill_in 'Passwort',     with: 'tester1234'

        click_on 'Als Anbieter anmelden'

        within_notifications do
          expect(page).to have_content('Sie müssen Ihre Email bestätigen, bevor Sie fortfahren können.')
        end
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

      fill_in 'Benutzername', with: 'rolf'
      fill_in 'Passwort',     with: 'tester1234'

      click_on 'Als Anbieter anmelden'

      within_notifications do
        expect(page).to have_content('Ihr Konto ist nicht aktiv')
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

    scenario 'using invalid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Anbieter'

      fill_in 'Benutzername', with: 'dani'
      fill_in 'Passwort',     with: 'tester'

      click_on 'Als Anbieter anmelden'

      within_notifications do
        expect(page).to have_content('Ungültige Anmeldedaten')
      end
    end

    scenario 'using valid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Anbieter'

      fill_in 'Benutzername', with: 'rolf'
      fill_in 'Passwort',     with: 'tester1234'

      click_on 'Als Anbieter anmelden'

      within_notifications do
        expect(page).to have_content('Erfolgreich angemeldet')
      end

      expect(current_path).to eql('/provider/dashboard')
    end
  end
end
