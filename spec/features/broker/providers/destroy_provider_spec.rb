# coding: UTF-8

require 'spec_helper'

feature 'Destroy a provider' do
  let(:user) do
    Fabricate(:broker_with_regions)
  end

  background do
    Fabricate(:provider, {
      firstname: 'Dora',
      lastname: 'Doretty',
      zip: '1235',
      city: 'Hierwil'
    })

    login_as(user, scope: :broker)
  end

  scenario 'displays the provider in the broker region' do
    visit '/broker/dashboard'
    click_on 'Alle Anbieter anzeigen'
    click_on 'Dora Doretty löschen'

    within_notifications do
      expect(page).to have_content('Anbieter wurde erfolgreich gelöscht.')
    end
  end

 end
