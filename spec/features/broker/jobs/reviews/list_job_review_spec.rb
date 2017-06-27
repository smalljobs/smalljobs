# coding: UTF-8

require 'spec_helper'

feature 'List the job reviews' do
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
    Fabricate(:review, {
      job: job,
      seeker: seeker_A,
      rating: 5,
      message: 'Super netter Herr!',
    })

    Fabricate(:review, {
      job: job,
      seeker: seeker_B,
      rating: 3,
      message: 'Ein bisschen streng war es.',
    })

    login_as(broker, scope: :broker)
  end

  scenario 'displays the jobs reviews' do
    visit_on broker, '/broker/dashboard'

    click_on 'Alle Jobs anzeigen'
    click_on 'Job 1 anzeigen'
    click_on 'Bewertungen'

    expect(page).to have_content 'Roberto'
    expect(page).to have_content 'Blanco'
    expect(page).to have_content '5 Punkte'
    expect(page).to have_content 'Super netter Herr!'

    expect(page).to have_content 'Susi'
    expect(page).to have_content 'Sorglos'
    expect(page).to have_content '3 Punkte'
    expect(page).to have_content 'Ein bisschen streng war es.'
  end

 end
