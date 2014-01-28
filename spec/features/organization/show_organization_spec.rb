# coding: UTF-8

require 'spec_helper'

feature 'Organization subdomain' do

  let(:org) { Fabricate(:org_lenzburg) }
  let(:region) { org.regions.first }

  scenario 'shows the organization details' do
    visit_on region, '/brokers/sign_up'

    expect(page).to have_content('Jugendarbeit Lenzburg')
    expect(page).to have_content('regionale Jugendarbeit Lotten')

    expect(page).to have_content('c/o JA Lenzburg, Soziale Dienste')
    expect(page).to have_content('5600 Lenzburg')

    expect(page).to have_content('062 508 13 14')
    expect(page).to have_content('info@jugendarbeit-lotten.ch')
    expect(page).to have_content('www.jugendarbeit-lotten.ch')

    expect(page).to have_content('Niederlenz')
    expect(page).to have_content('Boniswil')
    expect(page).to have_content('Egliswil')
    expect(page).to have_content('Seon')

    expect(page).to have_content('Mich Wyser')
    expect(page).to have_content('062 897 01 21')
  end

end
