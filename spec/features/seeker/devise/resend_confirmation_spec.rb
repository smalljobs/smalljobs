# coding: UTF-8

require 'spec_helper'

feature 'Resend confirmation' do
  let(:region) { Fabricate(:region_bremgarten) }

  scenario 'Unknown email' do
    visit_on region, '/'

    click_on 'Anmelden'
    click_on 'Sucher'
    click_on 'Keine Email zur Bestätigung erhalten?'

    fill_in 'Email', with: 'inexistent@example.com'
    click_on 'Bestätigung senden'

    expect(page).to have_content('nicht gefunden')
  end

  context 'for an already confirmed user' do
    before { Fabricate(:seeker, email: 'rolf@example.com', place: region.places.first, confirmed: true) }

    scenario 'Resend the confirmation email' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Sucher'
      click_on 'Keine Email zur Bestätigung erhalten?'

      fill_in 'Email', with: 'rolf@example.com'
      click_on 'Bestätigung senden'

      expect(page).to have_content('wurde bereits bestätigt')
    end
  end

  context 'for an unconfirmed user' do
    before { Fabricate(:seeker, email: 'rolf@example.com', place: region.places.first, confirmed: false, active: false) }

    scenario 'Resend the confirmation email' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Sucher'
      click_on 'Keine Email zur Bestätigung erhalten?'

      fill_in 'Email', with: 'rolf@example.com'
      click_on 'Bestätigung senden'

      within_notifications do
        expect(page).to have_content('Sie erhalten in wenigen Minuten eine E-Mail, mit der Sie Ihre Registrierung bestätigen können.')
      end

      open_email('rolf@example.com')
      current_email.click_link 'Email bestätigen'

      within_notifications do
        expect(page).to have_content('Vielen Dank für Ihre Bestätigung. Wir werden uns in Kürze bei Ihnen melden um ihr Konto zu aktivieren.')
      end

      expect(current_path).to eql('/')
    end
  end

  context 'for an unconfirmed, active user' do
    before { Fabricate(:seeker, email: 'rolf@example.com', place: region.places.first, confirmed: false, active: true) }

    scenario 'Resend the confirmation email' do
      visit_on region, '/'

      click_on 'Anmelden'
      click_on 'Sucher'
      click_on 'Keine Email zur Bestätigung erhalten?'

      fill_in 'Email', with: 'rolf@example.com'
      click_on 'Bestätigung senden'

      within_notifications do
        expect(page).to have_content('Sie erhalten in wenigen Minuten eine E-Mail, mit der Sie Ihre Registrierung bestätigen können.')
      end

      open_email('rolf@example.com')
      current_email.click_link 'Email bestätigen'

      within_notifications do
        expect(page).to have_content('Vielen Dank für Ihre Bestätigung.')
      end

      expect(current_path).to eql('/')
    end
  end
end

