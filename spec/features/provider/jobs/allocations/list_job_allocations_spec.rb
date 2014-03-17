# coding: UTF-8

require 'spec_helper'

feature 'List the job allocations' do
  let(:provider) { Fabricate(:provider) }

  let(:seeker_A) do
    Fabricate(:seeker,
              place: provider.place,
              firstname: 'Roberto',
              lastname: 'Blanco',
              street: 'Vordergasse 21',
              email: 'a@seeker.com',
              phone: '044 123 45 67',
              mobile: '079 123 45 67')
  end

  let(:seeker_B) do
    Fabricate(:seeker,
              place: provider.place,
              firstname: 'Susi',
              lastname: 'Sorglos',
              street: 'Hintergasse 12',
              email: 'b@seeker.com',
              phone: '044 765 43 21',
              mobile: '079 765 43 21')
  end

  let(:job) do
    Fabricate(:job, {
      provider: provider,
      place: provider.place,
      title: 'Job 1'
    })
  end

  background do
    Fabricate(:allocation, {
      job: job,
      seeker: seeker_A,
      message: 'Um 10 Uhr da sein!',
    })

    Fabricate(:allocation, {
      job: job,
      seeker: seeker_B,
      message: 'Achtung, nur bei schönem Wetter',
    })

    login_as(provider, scope: :provider)
  end

  scenario 'displays the jobs allocations' do
    visit_on provider, '/provider/dashboard'

    click_on 'Alle ihre Jobs anzeigen'
    click_on 'Job 1 anzeigen'
    click_on 'Zuweisungen'

    expect(page).to have_content 'Roberto'
    expect(page).to have_content 'Blanco'
    expect(page).to have_content 'a@see'
    expect(page).to have_content 'Vordergasse 21'
    expect(page).to have_content '044 123 45 67'
    expect(page).to have_content '079 123 45 67'

    expect(page).to have_content 'Susi'
    expect(page).to have_content 'Sorglos'
    expect(page).to have_content 'b@seeker.com'
    expect(page).to have_content 'Hintergasse 12'
    expect(page).to have_content '044 765 43 21'
    expect(page).to have_content '079 765 43 21'
  end

end
