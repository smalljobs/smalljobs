# coding: UTF-8

require 'spec_helper'

feature 'Destroy a job' do
  let(:provider) do
    Fabricate(:provider_with_region)
  end

  background do
    Fabricate(:job, {
      title: 'Langweilige Arbeit',
      provider: provider
    })

    login_as(provider, scope: :provider)
  end

  scenario 'remove the job' do
    visit_on provider, '/provider/dashboard'

    click_on 'Alle ihre Jobs anzeigen'
    click_on 'Langweilige Arbeit löschen'

    within_notifications do
      expect(page).to have_content('Job wurde erfolgreich gelöscht.')
    end
  end

 end
