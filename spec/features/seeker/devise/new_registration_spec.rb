# coding: UTF-8

require 'spec_helper'

feature 'New job seeker registration' do

  let(:org) { Fabricate(:org_lenzburg) }
  let(:region) { org.regions.first }

  background do
    Fabricate(:work_category, name: 'Garten')
    Fabricate(:work_category, name: 'Tiere')
    Fabricate(:work_category, name: 'Computer')

    Fabricate(:seeker, email: 'existing@example.com')
  end

  scenario 'with a duplicate email' do
    visit_on region, '/'

    click_on 'Als Jugendlicher registrieren'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Email',               with: 'existing@example.com'
      fill_in 'Passwort',            with: 'chicksonspeed'
      fill_in 'Passwortbestätigung', with: 'chicksonspeed'
    end

    click_on 'Als Jugendlicher registrieren'

    within_fieldset 'Anmeldedaten' do
      expect(page).to have_content('ist bereits vergeben')
    end
  end

  scenario 'without accepting the terms' do
    visit_on region, '/'

    click_on 'Als Jugendlicher registrieren'

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

      select 'Lenzburg', from: 'Ort'
    end

    within_fieldset 'Arbeit' do
      check 'Computer'
    end

    click_on 'Als Jugendlicher registrieren'

    within_fieldset 'Bedingungen' do
      expect(page).to have_content('Die Bedingungen müssen akzeptiert werden.')
    end
  end

  scenario 'with valid data' do
    visit_on region, '/'

    click_on 'Als Jugendlicher registrieren'

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

      select 'Lenzburg', from: 'Ort'
    end

    within_fieldset 'Arbeit' do
      check 'Computer'
    end

    within_fieldset 'Bedingungen' do
      check 'Ich akzeptiere'
    end

    click_on 'Als Jugendlicher registrieren'

    within_notifications do
      expect(page).to have_content('Sie erhalten in wenigen Minuten eine E-Mail mit einem Link für die Bestätigung der Registrierung. Klicken Sie auf den Link um Ihr Konto zu bestätigen.')
    end

    open_email('rolf@example.com')
    current_email.click_link('Email bestätigen')

    within_notifications do
      expect(page).to have_content('Vielen Dank für Ihre Bestätigung. Wir werden uns in Kürze bei Ihnen melden um ihr Konto zu aktivieren.')
    end

    expect(current_path).to eql('/')
  end

end
