# coding: UTF-8

require 'spec_helper'

feature 'Add a new job review' do
  let(:seeker) { Fabricate(:seeker) }
  let(:provider) { Fabricate(:provider, place: seeker.place, firstname: 'John', lastname: 'Johnetty') }

  let(:job) do
    Fabricate(:job, {
      provider:  provider,
      place: provider.place,
      title: 'Job 1'
    })
  end

  background do
    Fabricate(:allocation,
              job: job,
              seeker: seeker)

    login_as(seeker, scope: :seeker)
  end

  scenario 'with valid data' do
    visit_on seeker, '/seeker/dashboard'

    click_on 'Alle Jobs in der Region anzeigen'
    click_on 'Job 1 anzeigen'

    click_on 'Bewertungen'
    click_on 'Neue Bewertung hinzufügen'

    within_fieldset 'Bewertung' do
      select 'John Johnetty', from: 'Anbieter'
      select '5', from: 'Bewertung'
      fill_in 'Nachricht', with: 'Der war aber nett'
    end

    click_on 'Erstellen'

    within_notifications do
      expect(page).to have_content('Bewertung wurde erfolgreich erstellt.')
    end
  end
end
