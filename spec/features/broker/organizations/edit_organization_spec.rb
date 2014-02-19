# coding: UTF-8

require 'spec_helper'

feature 'Edit a provider' do
  let(:region) { Fabricate(:region_lenzburg) }

  let(:broker) do
    Fabricate(:broker_with_regions, place: region.places.first)
  end

  background do
    login_as(broker, scope: :broker)
  end

  scenario 'updates the organization data' do
    visit_on broker, '/broker/dashboard'

    click_on 'Organisation bearbeiten'

    within_fieldset 'Organisation' do
      fill_in 'Name',         with: 'JugendPlus'
      fill_in 'Beschreibung', with: 'Plus Minus'
      fill_in 'Strasse',      with: 'Voltstrasse 123'

      select 'Egliswil', from: 'Ort'
    end

    within_fieldset 'Kontakt' do
      fill_in 'Webseite', with: 'http://www.jugendplus.ch'
      fill_in 'Email',    with: 'jugend@jugendplus.ch'
      fill_in 'Telefon',  with: '044 123 123'
    end

    click_on 'Bearbeiten'

    within_notifications do
      expect(page).to have_content('Organisation wurde erfolgreich aktualisiert.')
    end
  end

 end
