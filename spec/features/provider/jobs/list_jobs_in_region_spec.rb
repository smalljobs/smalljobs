# coding: UTF-8

require 'spec_helper'

feature 'List the jobs' do
  let(:provider) do
    Fabricate(:provider_with_region)
  end

  background do
    Fabricate(:job, {
      title: 'Job 1',
      provider: provider
    })

    Fabricate(:job, {
      title: 'Job 2',
      provider: provider
    })

    Fabricate(:job, {
      title: 'Job 3'
    })

    login_as(provider, scope: :provider)
  end

  scenario 'displays the provider jobs' do
    visit_on provider, '/provider/dashboard'

    click_on 'Alle ihre Jobs anzeigen'

    expect(page).to have_content 'Job 1'
    expect(page).to have_content 'Job 2'
  end

  scenario 'hides the jobs not from the provider' do
    visit_on provider, '/provider/dashboard'
    click_on 'Alle ihre Jobs anzeigen'

    expect(page).to_not have_content 'Job 3'
  end

 end
