# coding: UTF-8

require 'spec_helper'

feature 'Destroy a seeker' do
  let(:user) do
    Fabricate(:broker_with_regions)
  end

  background do
    Fabricate(:seeker, {
      firstname: 'Dora',
      lastname: 'Doretty',
      zip: '1235',
      city: 'Hierwil'
    })

    login_as(user, scope: :broker)
  end

  scenario 'remove the seeker' do
    visit '/broker/dashboard'
    click_on 'Alle Sucher anzeigen'
    click_on 'Dora Doretty löschen'

    within_notifications do
      expect(page).to have_content('Sucher wurde erfolgreich gelöscht.')
    end
  end

 end
