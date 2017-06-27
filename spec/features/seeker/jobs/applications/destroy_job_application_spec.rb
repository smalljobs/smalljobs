# coding: UTF-8

require 'spec_helper'

feature 'Destroy a job application' do
  let(:seeker) { Fabricate(:seeker, firstname: 'Roberto', lastname: 'Blanco') }
  let(:provider) { Fabricate(:provider, place: seeker.place) }

  let(:job) do
    Fabricate(:job, {
      provider:  provider,
      place: provider.place,
      title: 'Job 1'
    })
  end

  background do
    Fabricate(:application, {
      job: job,
      seeker: seeker,
      message: 'War nicht schlecht',
    })

    login_as(seeker, scope: :seeker)
  end

  scenario 'remove the job application' do
    visit_on seeker, '/seeker/dashboard'

    click_on 'Alle Jobs in der Region anzeigen'
    click_on 'Job 1 anzeigen'

    click_on 'Bewerbungen'
    click_on 'Roberto Blanco Job 1 löschen'

    within_notifications do
      expect(page).to have_content('Bewerbung wurde erfolgreich gelöscht.')
    end
  end

 end
