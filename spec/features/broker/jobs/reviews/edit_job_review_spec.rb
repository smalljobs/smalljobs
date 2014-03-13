# coding: UTF-8

require 'spec_helper'

feature 'Edit a job review' do
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
      rating: 3,
      message: 'War nicht schlecht',
    })

    login_as(broker, scope: :broker)
  end

  scenario 'with valid data' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'
    click_on 'Job 1 anzeigen'

    click_on 'Bewertungen'
    click_on 'Roberto Blanco Job 1 bearbeiten'

    within_fieldset 'Bewertung' do
      select '4', from: 'Bewertung'
      fill_in 'Nachricht', with: 'Ganz ok.'
    end

    click_on 'Bearbeiten'

    within_notifications do
      expect(page).to have_content('Bewertung wurde erfolgreich aktualisiert.')
    end
  end

end
