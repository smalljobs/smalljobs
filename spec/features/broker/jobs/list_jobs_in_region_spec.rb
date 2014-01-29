# coding: UTF-8

require 'spec_helper'

feature 'List the jobs' do
  let(:broker) do
    Fabricate(:broker_with_regions)
  end

  background do
    Fabricate(:job, {
      provider: Fabricate(:provider, {
        firstname: 'John',
        lastname: 'Johnetty' }),
      place: broker.places.first,
      title: 'Job 1'
    })

    Fabricate(:job, {
      provider: Fabricate(:provider, {
        firstname: 'Dora',
        lastname: 'Doretty' }),
      place: broker.places.first,
      title: 'Job 2'
    })

    Fabricate(:job, {
      provider: Fabricate(:provider, {
        firstname: 'Jan',
        lastname: 'Janetty' }),
      place: Fabricate(:place, zip: '5432', name: 'Dawil'),
      title: 'Job 3'
    })

    login_as(broker, scope: :broker)
  end

  scenario 'displays the jobs in the broker region' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'

    expect(page).to have_content 'Job 1'
    expect(page).to have_content 'John'
    expect(page).to have_content 'Johnetty'

    expect(page).to have_content 'Job 2'
    expect(page).to have_content 'Dora'
    expect(page).to have_content 'Doretty'
  end

  scenario 'hides the jobs not in the broker region' do
    visit_on broker, '/broker/dashboard'
    click_on 'Alle Jobs anzeigen'

    expect(page).to_not have_content 'Job 3'
    expect(page).to_not have_content 'Jan'
    expect(page).to_not have_content 'Janetty'
  end

 end
