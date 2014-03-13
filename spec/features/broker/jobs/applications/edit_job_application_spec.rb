# coding: UTF-8

require 'spec_helper'

feature 'Edit a job application' do
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
    Fabricate(:application, {
      job: job,
      seeker: seeker,
      message: 'Das ist für mich',
    })

    login_as(broker, scope: :broker)
  end

  scenario 'with valid data' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'
    click_on 'Job 1 anzeigen'

    click_on 'Bewerbungen'
    click_on 'Roberto Blanco Job 1 bearbeiten'

    within_fieldset 'Nachricht' do
      fill_in 'Nachricht', with: 'Check this out'
    end

    click_on 'Bearbeiten'

    within_notifications do
      expect(page).to have_content('Bewerbung wurde erfolgreich aktualisiert.')
    end
  end

end
