# coding: UTF-8

require 'spec_helper'

feature 'List the job reviews' do
  let(:provider) { Fabricate(:provider, place: seeker.place, firstname: 'Roberto', lastname: 'Blanco') }
  let(:seeker) { Fabricate(:seeker) }

  let(:job) do
    Fabricate(:job, {
      provider:  provider,
      place: seeker.place,
      title: 'Job 1'
    })
  end

  background do
    Fabricate(:review, {
      job: job,
      provider: provider,
      rating: 5,
      message: 'Super netter Herr!',
    })

    login_as(seeker, scope: :seeker)
  end

  scenario 'displays the job reviews' do
    visit_on seeker, '/seeker/dashboard'

    click_on 'Alle Jobs in der Region anzeigen'
    click_on 'Job 1 anzeigen'
    click_on 'Bewertungen'

    expect(page).to have_content 'Roberto'
    expect(page).to have_content 'Blanco'
    expect(page).to have_content '5 Punkte'
    expect(page).to have_content 'Super netter Herr!'
  end

 end
