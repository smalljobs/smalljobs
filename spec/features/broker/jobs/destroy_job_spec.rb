# coding: UTF-8

require 'spec_helper'

feature 'Destroy a job' do
  let(:broker) do
    Fabricate(:broker_with_regions)
  end

  background do
    Fabricate(:job, {
      title: 'Langweilige Arbeit',
      place: broker.places.first
    })

    login_as(broker, scope: :broker)
  end

  scenario 'remove the job' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'
    click_on 'Langweilige Arbeit löschen'

    within_notifications do
      expect(page).to have_content('Job wurde erfolgreich gelöscht.')
    end
  end

 end
