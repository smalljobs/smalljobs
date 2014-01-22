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
      street: 'Rotmatt 28',
      zip: '1234',
      city: 'Dortwil',
      phone: '+41 0564444444',
      mobile: '+41 0794444444',
      email: 'john@example.com',
      contact_preference: 'mobile',
      contact_availability: 'Am Abend'
    })

    login_as(user, scope: :broker)
  end

  scenario 'displays all the user details' do
    visit '/broker/dashboard'
    click_on 'Alle Anbieter anzeigen'
    click_on 'Anzeigen'

    expect(page).to have_content('John')
    expect(page).to have_content('Johnetty')
    expect(page).to have_content('Rotmatt 28')
    expect(page).to have_content('1234')
    expect(page).to have_content('Dortwil')
    expect(page).to have_content('056 444 44 44')
    expect(page).to have_content('079 444 44 44')
    expect(page).to have_content('john@example.com')
    expect(page).to have_content('Bevorzugt Kontakt via Mobiltelefon')
    expect(page).to have_content('Am Besten erreichbar: Am Abend')
  end

 end
