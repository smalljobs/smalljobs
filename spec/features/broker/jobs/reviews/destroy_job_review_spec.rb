# coding: UTF-8

require 'spec_helper'

feature 'Destroy a job review' do
  let(:broker) { Fabricate(:broker_with_regions) }
  let(:seeker) { Fabricate(:seeker, place: broker.places.first, firstname: 'Roberto', lastname: 'Blanco') }

  let(:job) do
    Fabricate(:job, {
      provider: Fabricate(:provider, {
        firstname: 'John',
        lastname: 'Johnetty' }),
      place: broker.places.first,
      title: 'Job 1'
    })
  end

  background do
    Fabricate(:review, {
      job: job,
      seeker: seeker,
      rating: 5,
      message: 'War super',
    })

    login_as(broker, scope: :broker)
  end

  scenario 'remove the job review' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'
    click_on 'Job 1 anzeigen'

    click_on 'Bewertungen'
    click_on 'Roberto Blanco Job 1 löschen'

    within_notifications do
      expect(page).to have_content('Bewertung wurde erfolgreich gelöscht.')
    end
  end

 end
