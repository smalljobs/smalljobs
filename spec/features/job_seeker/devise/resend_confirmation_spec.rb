# coding: UTF-8

require 'spec_helper'

feature 'Resend confirmation' do
  scenario 'Unknown email' do
    visit '/'
    click_on 'Anmelden'
    click_on 'Sucher'
    click_on 'Keine Email zur Bestätigung erhalten?'

    fill_in 'Email', with: 'inexistent@example.com'
    click_on 'Bestätigung senden'

    expect(page).to have_content('nicht gefunden')
  end

  context 'for an already confirmed user' do
    let!(:user) { Fabricate(:job_seeker, email: 'rolf@example.com', confirmed: true) }

    scenario 'Resend the confirmation email' do
      visit '/'
      click_on 'Anmelden'
      click_on 'Sucher'
      click_on 'Keine Email zur Bestätigung erhalten?'

      fill_in 'Email', with: 'rolf@example.com'
      click_on 'Bestätigung senden'

      expect(page).to have_content('wurde bereits bestätigt')
    end
  end

  context 'for an unconfirmed user' do
    let!(:user) { Fabricate(:job_seeker, email: 'rolf@example.com', confirmed: false, active: false) }

    scenario 'Resend the confirmation email' do
      visit '/'
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
    let!(:user) { Fabricate(:job_seeker, email: 'rolf@example.com', confirmed: false, active: true) }

    scenario 'Resend the confirmation email' do
      visit '/'
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

