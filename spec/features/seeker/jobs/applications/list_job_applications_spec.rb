# coding: UTF-8

require 'spec_helper'

feature 'List the job applications' do
  let(:seeker_A) { Fabricate(:seeker, firstname: 'Roberto', lastname: 'Blanco') }
  let(:seeker_B) { Fabricate(:seeker, place: seeker_A.place, firstname: 'Susi', lastname: 'Sorglos') }

  let(:job) do
    Fabricate(:job, {
      place: seeker_A.place,
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

    login_as(seeker_A, scope: :seeker)
  end

  scenario 'displays the job application of the seeker' do
    visit_on seeker_A, '/seeker/dashboard'

    click_on 'Alle Jobs in der Region anzeigen'
    click_on 'Job 1 anzeigen'
    click_on 'Bewerbungen'

    expect(page).to have_content 'Den Job will ich'
  end

  scenario 'does not display the job application of the other seeker' do
    visit_on seeker_A, '/seeker/dashboard'

    click_on 'Alle Jobs in der Region anzeigen'
    click_on 'Job 1 anzeigen'
    click_on 'Bewerbungen'

    expect(page).to_not have_content 'Das ist mein Nachbar'
  end

 end
