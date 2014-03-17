# coding: UTF-8

require 'spec_helper'

feature 'Destroy a job review' do
  let(:provider) { Fabricate(:provider) }

  let(:job) do
    Fabricate(:job, {
      provider: provider,
      place: provider.place,
      title: 'Job 1'
    })
  end

  let(:seeker) { Fabricate(:seeker, place: provider.place, firstname: 'Roberto', lastname: 'Blanco') }

  background do
    Fabricate(:allocation, job: job, seeker: seeker)
    Fabricate(:review, job: job, seeker: seeker)
    login_as(provider, scope: :provider)
  end

  scenario 'remove the job review' do
    visit_on provider, '/provider/dashboard'

    click_on 'Alle ihre Jobs anzeigen'
    click_on 'Job 1 anzeigen'

    click_on 'Bewertungen'
    click_on 'Roberto Blanco Job 1 löschen'

    within_notifications do
      expect(page).to have_content('Bewertung wurde erfolgreich gelöscht.')
    end
  end

 end
