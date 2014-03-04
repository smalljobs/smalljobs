# coding: UTF-8

require 'spec_helper'

feature 'SHow a seeker' do
  let(:broker) do
    Fabricate(:broker_with_regions)
  end

  let(:category_1) { Fabricate(:work_category, name: 'Putzen') }
  let(:category_2) { Fabricate(:work_category, name: 'Rasen') }

  background do
    Fabricate(:seeker, {
      firstname: 'John',
      lastname: 'Johnetty',
      street: 'Rotmatt 28',
      place: broker.places.first,
      phone: '+41 0564444444',
      mobile: '+41 0794444444',
      email: 'john@example.com',
      contact_preference: 'mobile',
      contact_availability: 'Am Abend',
      date_of_birth: Date.new(1999, 1, 1),
      work_categories: [category_1, category_2]
    })

    login_as(broker, scope: :broker)
  end

  scenario 'displays all the user details' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jugendlichen anzeigen'
    click_on 'John Johnetty anzeigen'

    expect(page).to have_content('John')
    expect(page).to have_content('Johnetty')
    expect(page).to have_content('Rotmatt 28')
    expect(page).to have_content('1234')
    expect(page).to have_content('Vessy')
    expect(page).to have_content('1. Januar 1999')
    expect(page).to have_content('056 444 44 44')
    expect(page).to have_content('079 444 44 44')
    expect(page).to have_content('john@example.com')
    expect(page).to have_content('Mobiltelefon')
    expect(page).to have_content('Am Abend')
    expect(page).to have_content('Putzen')
    expect(page).to have_content('Rasen')
  end

end
