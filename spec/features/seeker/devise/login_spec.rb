# coding: UTF-8

require 'spec_helper'

feature 'Login' do
  let(:region) { Fabricate(:region, name: 'Bremgarten') }

  context 'with an unconfirmed user' do
    background do
      Fabricate(:seeker,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                place: region.places.first,
                confirmed: false,
                active: false)
    end

    scenario 'using valid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Sucher'

      fill_in 'Email',    with: 'rolf@example.com'
      fill_in 'Passwort', with: 'tester1234'

      click_on 'Als Sucher anmelden'

      within_notifications do
        expect(page).to have_content('Sie müssen Ihren Email bestätigen, bevor Sie fortfahren können.')
      end
    end
  end

  context 'with an inactive user' do
    background do
      Fabricate(:seeker,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                place: region.places.first,
                confirmed: true,
                active: false)
    end

    scenario 'using valid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Sucher'

      fill_in 'Email',    with: 'rolf@example.com'
      fill_in 'Passwort', with: 'tester1234'

      click_on 'Als Sucher anmelden'

      within_notifications do
        expect(page).to have_content('Ihr Konto ist nicht aktiv')
      end
    end
  end

  context 'with an active user' do
    background do
      Fabricate(:seeker,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                place: region.places.first,
                confirmed: true,
                active: true)
    end

    scenario 'using invalid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Sucher'

      fill_in 'Email',    with: 'dani'
      fill_in 'Passwort', with: 'tester'

      click_on 'Als Sucher anmelden'

      within_notifications do
        expect(page).to have_content('Ungültige Anmeldedaten')
      end
    end

    scenario 'using valid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Sucher'

      fill_in 'Email',    with: 'rolf@example.com'
      fill_in 'Passwort', with: 'tester1234'

      click_on 'Als Sucher anmelden'

      within_notifications do
        expect(page).to have_content('Erfolgreich angemeldet')
      end

      expect(current_path).to eql('/seeker/dashboard')
    end
  end
end
