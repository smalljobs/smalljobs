# coding: UTF-8

require 'spec_helper'

feature 'Destroy a job review' do
  let(:seeker) { Fabricate(:seeker) }
  let(:provider) { Fabricate(:provider, place: seeker.place, firstname: 'Roberto', lastname: 'Blanco') }

  let(:job) do
    Fabricate(:job, {
      provider:  provider,
      place: provider.place,
      title: 'Job 1'
    })
  end

  background do
    Fabricate(:review, {
      job: job,
      provider: provider,
      rating: 3,
      message: 'War nicht schlecht',
    })

    login_as(seeker, scope: :seeker)
  end

  scenario 'remove the job review' do
    visit_on seeker, '/seeker/dashboard'

    click_on 'Alle Jobs in der Region anzeigen'
    click_on 'Job 1 anzeigen'

    click_on 'Bewertungen'
    click_on 'Roberto Blanco Job 1 löschen'

    within_notifications do
      expect(page).to have_content('Bewertung wurde erfolgreich gelöscht.')
    end
  end

 end
