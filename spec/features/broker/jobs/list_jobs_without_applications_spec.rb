# coding: UTF-8

require 'spec_helper'

feature 'List the jobs without applications' do
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

    job = Fabricate(:job, {
      provider: Fabricate(:provider, {
        firstname: 'Dora',
        lastname: 'Doretty' }),
      place: broker.places.first,
      title: 'Job 2'
    })

    Fabricate(:application, job: job)

    login_as(broker, scope: :broker)
  end

  scenario 'filters the jobs by application count' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'

    expect(page).to have_content 'Job 1'
    expect(page).to have_content 'John'
    expect(page).to have_content 'Johnetty'

    expect(page).to have_content 'Job 2'
    expect(page).to have_content 'Dora'
    expect(page).to have_content 'Doretty'

    click_on 'Ohne Bewerbungen'

    expect(page).to have_content 'Job 1'
    expect(page).to have_content 'John'
    expect(page).to have_content 'Johnetty'

    expect(page).to_not have_content 'Job 2'
    expect(page).to_not have_content 'Dora'
    expect(page).to_not have_content 'Doretty'

    click_on 'Alle'

    expect(page).to have_content 'Job 1'
    expect(page).to have_content 'John'
    expect(page).to have_content 'Johnetty'

    expect(page).to have_content 'Job 2'
    expect(page).to have_content 'Dora'
    expect(page).to have_content 'Doretty'
  end

 end
