# coding: UTF-8

require 'spec_helper'

feature 'New job provider registration' do

  let(:region) { Fabricate(:region, name: 'Bremgarten') }

  background do
    Fabricate(:provider, username: 'existing')
    Fabricate(:provider, email: 'existing@example.com')
  end

  scenario 'with a duplicate username' do
    visit_on region, '/'

    click_on 'Als Anbieter registrieren'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Benutzername',        with: 'existing'
      fill_in 'Passwort',            with: 'chicksonspeed'
      fill_in 'Passwortbestätigung', with: 'chicksonspeed'
    end

    click_on 'Als Anbieter registrieren'

    within_fieldset 'Anmeldedaten' do
      expect(page).to have_content('ist bereits vergeben')
    end
  end

  scenario 'with a duplicate email' do
    visit_on region, '/'

    click_on 'Als Anbieter registrieren'

    within_fieldset 'Kontakt' do
      fill_in 'Email',  with: 'existing@example.com'
    end

    click_on 'Als Anbieter registrieren'

    within_fieldset 'Kontakt' do
      expect(page).to have_content('ist bereits vergeben')
    end
  end

  scenario 'without an email' do
    visit_on region, '/'

    click_on 'Als Anbieter registrieren'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Benutzername',        with: 'meier'
      fill_in 'Passwort',            with: 'chicksonspeed'
      fill_in 'Passwortbestätigung', with: 'chicksonspeed'
    end

    within_fieldset 'Adresse' do
      fill_in 'Vorname',  with: 'Rolf'
      fill_in 'Nachname', with: 'Meier'
      fill_in 'Strasse',  with: 'Hühnerstall 12'
      fill_in 'PLZ',      with: '1234'
      fill_in 'Ort',      with: 'Gockelwil'
    end

    click_on 'Als Anbieter registrieren'

    within_notifications do
      expect(page).to have_content('Da Sie keine Email angegeben haben, müssen wir Sie zur Bestätigung persönlich kontaktieren. Wir werden uns in Kürze bei Ihnen melden.')
    end

    expect(current_path).to eql('/')
  end

  scenario 'with a valid email' do
    visit_on region, '/'

    click_on 'Als Anbieter registrieren'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Benutzername',        with: 'meier'
      fill_in 'Passwort',            with: 'chicksonspeed'
      fill_in 'Passwortbestätigung', with: 'chicksonspeed'
    end

    within_fieldset 'Adresse' do
      fill_in 'Vorname',  with: 'Rolf'
      fill_in 'Nachname', with: 'Meier'
      fill_in 'Strasse',  with: 'Hühnerstall 12'
      fill_in 'PLZ',      with: '1234'
      fill_in 'Ort',      with: 'Gockelwil'
    end

    within_fieldset 'Kontakt' do
      fill_in 'Email',  with: 'rolf@example.com'
    end

    click_on 'Als Anbieter registrieren'

    within_notifications do
      expect(page).to have_content('Sie erhalten in wenigen Minuten eine E-Mail mit einem Link für die Bestätigung der Registrierung. Klicken Sie auf den Link um Ihren Konto zu bestätigen.')
    end

    open_email('rolf@example.com')
    current_email.click_link('Email bestätigen')

    within_notifications do
      expect(page).to have_content('Vielen Dank für Ihre Bestätigung. Wir werden uns in Kürze bei Ihnen melden um ihr Konto zu aktivieren.')
    end

    expect(current_path).to eql('/')
  end

  context 'from the admin backend' do
    let(:admin) { Fabricate(:admin) }

    background do
      login_as(admin, scope: :admin)
    end

    scenario 'invites a new job provider' do
      visit '/admin'
      click_on 'Anbieter'
      click_on 'Neu hinzufügen'

      within_fieldset 'Authentifizierung' do
        fill_in 'Benutzername', with: 'yolo'
        fill_in 'Passwort', with: 'tester1234'
      end

      within_fieldset 'Adresse' do
        fill_in 'Vorname',   with: 'Rolf'
        fill_in 'Nachname',  with: 'Meier'
        fill_in 'Strasse',   with: 'Hühnerstall 12'
        fill_in 'PLZ',       with: '1234'
        fill_in 'Ort',       with: 'Gockelwil'
      end

      within_fieldset 'Kontakt' do
        fill_in 'Email',   with: 'rolf@example.com'
        fill_in 'Telefon', with: '044 444 44 44'
        fill_in 'Mobile',  with: '079 333 33 33'
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
