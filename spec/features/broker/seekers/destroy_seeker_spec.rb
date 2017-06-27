# coding: UTF-8

require 'spec_helper'

feature 'Destroy a seeker' do
  let(:broker) do
    Fabricate(:broker_with_regions)
  end

  background do
    Fabricate(:seeker, {
      firstname: 'Dora',
      lastname: 'Doretty',
      place: broker.places.first
    })

    login_as(broker, scope: :broker)
  end

  scenario 'remove the seeker' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jugendlichen anzeigen'
    click_on 'Dora Doretty löschen'

    within_notifications do
      expect(page).to have_content('Jugendlicher wurde erfolgreich gelöscht.')
    end
  end

 end
