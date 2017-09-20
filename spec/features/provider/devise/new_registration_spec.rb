# coding: UTF-8

require_relative '../../../spec_helper'

feature 'New job provider registration' do

  let(:org) { Fabricate(:org_lenzburg) }
  let(:region) { org.regions.first }

  background do
    Fabricate(:provider, email: 'existing@example.com')
  end

  scenario 'with a duplicate email' do
    visit_on region, '/'

    click_on 'Registrieren'
    click_on 'Job ausschreiben'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Email',  with: 'existing@example.com'
    end

    click_on 'Registrieren und Job erfassen'

    within_fieldset 'Anmeldedaten' do
      expect(page).to have_content('ist bereits vergeben')
    end
  end

  scenario 'without accepting the terms' do
    visit_on region, '/'

    click_on 'Registrieren'
    click_on 'Job ausschreiben'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Email',  with: 'rolf@example.com'
      fill_in 'Passwort',            with: 'chicksonspeed'
      fill_in 'Passwortbestätigung', with: 'chicksonspeed'
    end

    within_fieldset 'Adresse' do
      fill_in 'Vorname',  with: 'Rolf'
      fill_in 'Nachname', with: 'Meier'
      fill_in 'Strasse',  with: 'Hühnerstall 12'

      select 'Lenzburg', from: 'Ort'
    end

    click_on 'Registrieren und Job erfassen'

    within_fieldset 'Bedingungen' do
      expect(page).to have_content('Die Bedingungen müssen akzeptiert werden.')
    end
  end

  scenario 'without an email' do
    visit_on region, '/'

    click_on 'Registrieren'
    click_on 'Job ausschreiben'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Passwort',            with: 'chicksonspeed'
      fill_in 'Passwortbestätigung', with: 'chicksonspeed'
    end

    within_fieldset 'Adresse' do
      fill_in 'Vorname',  with: 'Rolf'
      fill_in 'Nachname', with: 'Meier'
      fill_in 'Strasse',  with: 'Hühnerstall 12'

      select 'Lenzburg', from: 'Ort'
    end

    within_fieldset 'Bedingungen' do
      check 'Ich akzeptiere'
    end

    click_on 'Registrieren und Job erfassen'

    expect(current_path).to eql('/providers')
  end

  scenario 'with a valid email' do
    visit_on region, '/'

    click_on 'Registrieren'
    click_on 'Job ausschreiben'

    within_fieldset 'Anmeldedaten' do
      fill_in 'Email',  with: 'rolf@example.com'
      fill_in 'Passwort',            with: 'chicksonspeed'
      fill_in 'Passwortbestätigung', with: 'chicksonspeed'
    end

    within_fieldset 'Adresse' do
      fill_in 'Vorname',  with: 'Rolf'
      fill_in 'Nachname', with: 'Meier'
      fill_in 'Strasse',  with: 'Hühnerstall 12'

      select 'Lenzburg', from: 'Ort'
    end

    within_fieldset 'Bedingungen' do
      check 'Ich akzeptiere'
    end

    click_on 'Registrieren und Job erfassen'

    expect(current_path).to eql('/providers')
  end

end
