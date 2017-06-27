# coding: UTF-8

require 'spec_helper'

feature 'List the job applications' do
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
    Fabricate(:application, {
      job: job,
      seeker: seeker_A,
      message: 'Den Job will ich',
    })

    Fabricate(:application, {
      job: job,
      seeker: seeker_B,
      message: 'Das ist mein Nachbar!',
    })

    login_as(broker, scope: :broker)
  end

  scenario 'displays the jobs applications' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'
    click_on 'Job 1 anzeigen'
    click_on 'Bewerbungen'

    expect(page).to have_content 'Roberto'
    expect(page).to have_content 'Blanco'
    expect(page).to have_content 'Den Job will ich'

    expect(page).to have_content 'Susi'
    expect(page).to have_content 'Sorglos'
    expect(page).to have_content 'Das ist mein Nachbar'
  end

 end
