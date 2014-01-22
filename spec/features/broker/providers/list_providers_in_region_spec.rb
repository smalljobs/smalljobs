# coding: UTF-8

require 'spec_helper'

feature 'List the providers' do
  let(:user) do
    Fabricate(:broker_with_regions)
  end

  background do
    Fabricate(:provider, {
      firstname: 'John',
      lastname: 'Johnetty',
      zip: '1234',
      city: 'Dortwil'
    })

    Fabricate(:provider, {
      firstname: 'Dora',
      lastname: 'Doretty',
      zip: '1235',
      city: 'Hierwil'
    })

    Fabricate(:provider, {
      firstname: 'Jan',
      lastname: 'Janetty',
      zip: '5432',
      city: 'Dawil'
    })

    login_as(user, scope: :broker)
  end

  scenario 'displays the provider in the broker region' do
    visit '/broker/dashboard'
    click_on 'Alle Anbieter anzeigen'

    expect(page).to have_content 'John'
    expect(page).to have_content 'Johnetty'
    expect(page).to have_content '1234'
    expect(page).to have_content 'Dortwil'

    expect(page).to have_content 'Dora'
    expect(page).to have_content 'Doretty'
    expect(page).to have_content '1235'
    expect(page).to have_content 'Hierwil'
  end

  scenario 'hides the provider not in the broker region' do
    visit '/broker/dashboard'
    click_on 'Alle Anbieter anzeigen'

    expect(page).to_not have_content 'Jan'
    expect(page).to_not have_content 'Janetty'
    expect(page).to_not have_content '5432'
    expect(page).to_not have_content 'Dawil'
  end

 end
