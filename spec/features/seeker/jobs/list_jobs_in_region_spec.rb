# coding: UTF-8

require 'spec_helper'

feature 'List the jobs' do
  let(:seeker) do
    Fabricate(:seeker)
  end

  let(:provider) do
    Fabricate(:provider, place: seeker.place)
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

    login_as(seeker, scope: :seeker)
  end

  scenario 'displays the jobs in the seekers area' do
    visit_on seeker, '/seeker/dashboard'

    click_on 'Alle Jobs in der Region anzeigen'

    expect(page).to have_content 'Job 1'
    expect(page).to have_content 'Job 2'
  end

  scenario 'hides the jobs not in the seekers area' do
    visit_on seeker, '/seeker/dashboard'
    click_on 'Alle Jobs in der Region anzeigen'

    expect(page).to_not have_content 'Job 3'
  end

 end
