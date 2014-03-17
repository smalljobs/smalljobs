# coding: UTF-8

require 'spec_helper'

feature 'List the job proposals' do
  let(:seeker_A) { Fabricate(:seeker, firstname: 'Roberto', lastname: 'Blanco') }
  let(:seeker_B) { Fabricate(:seeker, place: seeker_A.place, firstname: 'Susi', lastname: 'Sorglos') }

  let(:job) do
    Fabricate(:job, {
      place: seeker_A.place,
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

    login_as(seeker_A, scope: :seeker)
  end

  scenario 'displays the job proposal for the seeker' do
    visit_on seeker_A, '/seeker/dashboard'

    click_on 'Alle Jobs in der Region anzeigen'
    click_on 'Job 1 anzeigen'
    click_on 'Vorschläge'

    expect(page).to have_content 'Roberto'
    expect(page).to have_content 'Blanco'
    expect(page).to have_content 'Das ist doch was für dich'
  end

  scenario 'does not display the job proposals of the other seeker' do
    visit_on seeker_A, '/seeker/dashboard'

    click_on 'Alle Jobs in der Region anzeigen'
    click_on 'Job 1 anzeigen'
    click_on 'Vorschläge'

    expect(page).to_not have_content 'Susi'
    expect(page).to_not have_content 'Sorglos'
    expect(page).to_not have_content 'Check this out'
  end

end
