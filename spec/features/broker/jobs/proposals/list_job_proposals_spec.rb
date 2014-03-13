# coding: UTF-8

require 'spec_helper'

feature 'List the job proposals' do
  let(:broker) { Fabricate(:broker_with_regions) }
  let(:seeker_A) { Fabricate(:seeker, place: broker.places.first, firstname: 'Roberto', lastname: 'Blanco') }
  let(:seeker_B) { Fabricate(:seeker, place: broker.places.first, firstname: 'Susi', lastname: 'Sorglos') }

  let(:job) do
    Fabricate(:job, {
      provider: Fabricate(:provider, {
        firstname: 'John',
        lastname: 'Johnetty' }),
      place: broker.places.first,
      title: 'Job 1'
    })
  end

  background do
    Fabricate(:proposal, {
      job: job,
      seeker: seeker_A,
      message: 'Das ist doch was für dich',
    })

    Fabricate(:proposal, {
      job: job,
      seeker: seeker_B,
      message: 'Check this out',
    })

    login_as(broker, scope: :broker)
  end

  scenario 'displays the jobs proposals' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'
    click_on 'Job 1 anzeigen'
    click_on 'Vorschläge'

    expect(page).to have_content 'Roberto'
    expect(page).to have_content 'Blanco'
    expect(page).to have_content 'Das ist doch was für dich'

    expect(page).to have_content 'Susi'
    expect(page).to have_content 'Sorglos'
    expect(page).to have_content 'Check this out'
  end

 end
