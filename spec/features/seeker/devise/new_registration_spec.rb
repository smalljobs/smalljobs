# coding: UTF-8

require 'spec_helper'

feature 'New job seeker registration' do
  background do
    Fabricate(:work_category, name: 'Garten')
    Fabricate(:work_category, name: 'Tiere')
    Fabricate(:work_category, name: 'Computer')

    Fabricate(:seeker, email: 'existing@example.com')
  end

  scenario 'with a duplicate email' do
    visit '/'
    click_on 'Als Sucher registrieren'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Email',               with: 'existing@example.com'
      fill_in 'Passwort',            with: 'chicksonspeed'
      fill_in 'Passwortbestätigung', with: 'chicksonspeed'
    end

    click_on 'Als Sucher registrieren'

    within_fieldset 'Anmeldedaten' do
      expect(page).to have_content('ist bereits vergeben')
    end
  end

  scenario 'with valid data' do
    visit '/'
    click_on 'Als Sucher registrieren'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Email',               with: 'rolf@example.com'
      fill_in 'Passwort',            with: 'chicksonspeed'
      fill_in 'Passwortbestätigung', with: 'chicksonspeed'
      select_date 15.years.ago,      from: 'Geburtsdatum'
    end

    within_fieldset 'Adresse' do
      fill_in 'Vorname',  with: 'Rolf'
      fill_in 'Nachname', with: 'Meier'
      fill_in 'Strasse',  with: 'Hühnerstall 12'
      fill_in 'PLZ',      with: '1234'
      fill_in 'Ort',      with: 'Gockelwil'
    end

    within_fieldset 'Arbeit' do
      check 'Computer'
    end

    click_on 'Als Sucher registrieren'

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

    scenario 'invites a new job seeker' do
      visit '/admin'
      click_on 'Sucher'
      click_on 'Neu hinzufügen'

      within_fieldset 'Authentifizierung' do
        fill_in 'Email',        with: 'rolf@example.com'
        fill_in 'Passwort',     with: 'tester1234'
        fill_in 'Geburtsdatum', with: '1.1.1998'
      end

      within_fieldset 'Adresse' do
        fill_in 'Vorname',   with: 'Rolf'
        fill_in 'Nachname',  with: 'Meier'
        fill_in 'Strasse',   with: 'Hühnerstall 12'
        fill_in 'PLZ',       with: '1234'
        fill_in 'Ort',       with: 'Gockelwil'
      end

      within_fieldset 'Kontakt' do
        fill_in 'Telefon', with: '044 444 44 44'
        fill_in 'Mobile', with: '079 333 33 33'
      end

      within_fieldset 'Arbeiten' do
        select 'Computer', from: 'Bevorzugte Arbeiten'
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
