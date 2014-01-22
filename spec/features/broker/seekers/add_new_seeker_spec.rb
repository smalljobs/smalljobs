# coding: UTF-8

require 'spec_helper'

feature 'Add a new seeker' do
  let(:user) do
    Fabricate(:broker_with_regions)
  end

  background do
    Fabricate(:seeker, email: 'existing@example.com')
    Fabricate(:work_category, name: 'Garten')
    Fabricate(:work_category, name: 'Tiere')
    Fabricate(:work_category, name: 'Computer')

    login_as(user, scope: :broker)
  end

  scenario 'with a duplicate email' do
    visit '/broker/dashboard'
    click_on 'Alle Sucher anzeigen'
    click_on 'Neuen Sucher hinzufügen'

    fill_in_valid_data

    within_fieldset 'Anmeldedaten' do
      fill_in 'Email',  with: 'existing@example.com'
    end

    click_on 'Erstellen'

    within_fieldset 'Anmeldedaten' do
      expect(page).to have_content('ist bereits vergeben')
    end
  end

  scenario 'with valid data' do
    visit '/broker/dashboard'
    click_on 'Alle Sucher anzeigen'
    click_on 'Neuen Sucher hinzufügen'

    fill_in_valid_data
    click_on 'Erstellen'

    within_notifications do
      expect(page).to have_content('Sucher wurde erfolgreich erstellt.')
    end
  end

  private

  def fill_in_valid_data
    within_fieldset 'Anmeldedaten' do
      fill_in 'Email',               with: 'meier@example.com'
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

    within_fieldset 'Kontakt' do
      fill_in 'Telefon', with: '+41 044 444 44 44'
      fill_in 'Mobile',  with: '+41 079 444 44 44'
    end

    within_fieldset 'Arbeit' do
      check 'Computer'
    end
  end

end
