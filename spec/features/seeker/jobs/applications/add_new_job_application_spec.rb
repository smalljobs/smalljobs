# coding: UTF-8

require 'spec_helper'

feature 'Add a job application' do
  let(:seeker) { Fabricate(:seeker, firstname: 'Roberto', lastname: 'Blanco') }
  let(:provider) { Fabricate(:provider, place: seeker.place) }

  background do
    Fabricate(:job, {
      provider:  provider,
      place: provider.place,
      title: 'Job 1'
    })

    login_as(seeker, scope: :seeker)
  end

  scenario 'with valid data' do
    visit_on seeker, '/seeker/dashboard'

    click_on 'Alle Jobs in der Region anzeigen'
    click_on 'Job 1 anzeigen'

    click_on 'Bewerbungen'
    click_on 'Bewerbung erfassen'

    within_fieldset 'Bewerbung' do
      fill_in 'Nachricht', with: 'Ganz ok.'
    end

    click_on 'Erstellen'

    within_notifications do
      expect(page).to have_content('Bewerbung wurde erfolgreich erstellt.')
    end
  end

end

