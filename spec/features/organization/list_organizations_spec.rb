# coding: UTF-8

require_relative '../../spec_helper'

feature 'Main SmallJobs domain' do

  before do
    Fabricate(:org_bremgarten)
    Fabricate(:org_lenzburg)
  end

  scenario 'Lists the organizations' do
    visit_on '/'

    expect(page).to have_content('Jugendarbeit Bremgarten')
    expect(page).to have_content('Jugendarbeit Lenzburg')

    expect(page).to have_content('Region Bremgarten')
    expect(page).to have_content('Region Lenzburg')

    expect(page).to have_content('Bremgarten')
    expect(page).to have_content('Zufikon')
    expect(page).to have_content('Wohlen')

    expect(page).to have_content('Niederlenz')
    expect(page).to have_content('Boniswil')
    expect(page).to have_content('Egliswil')
    expect(page).to have_content('Seon')
    expect(page).to have_content('Lenzburg')


    expect(page).to have_link('Besuche Bremgarten', root_url(subdomain: 'bremgarten'))
    expect(page).to have_link('Besuche Lenzburg', root_url(subdomain: 'lenzburg'))
  end

end
