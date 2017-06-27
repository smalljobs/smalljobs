# coding: UTF-8

require 'spec_helper'

feature 'List the providers' do
  let(:broker) do
    Fabricate(:broker_with_regions)
  end

  background do
    Fabricate(:provider, {
      firstname: 'John',
      lastname: 'Johnetty',
      place: broker.places.first
    })

    Fabricate(:provider, {
      firstname: 'Dora',
      lastname: 'Doretty',
      place: broker.places.last
    })

    Fabricate(:provider, {
      firstname: 'Jan',
      lastname: 'Janetty',
      place: Fabricate(:place, zip: '5432', name: 'Dawil')
    })

    login_as(broker, scope: :broker)
  end

  scenario 'displays the provider in the broker region' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Anbieter anzeigen'

    expect(page).to have_content 'John'
    expect(page).to have_content 'Johnetty'
    expect(page).to have_content '1234'
    expect(page).to have_content 'Vessy'

    expect(page).to have_content 'Dora'
    expect(page).to have_content 'Doretty'
    expect(page).to have_content '1234'
    expect(page).to have_content 'Vessy'
  end

  scenario 'hides the provider not in the broker region' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Anbieter anzeigen'

    expect(page).to_not have_content 'Jan'
    expect(page).to_not have_content 'Janetty'
    expect(page).to_not have_content '5432'
    expect(page).to_not have_content 'Dawil'
  end

 end
