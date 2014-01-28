# coding: UTF-8

require 'spec_helper'

feature 'Logout' do

  let(:org) { Fabricate(:org_lenzburg) }
  let(:region) { org.regions.first }

  let(:user) do
    Fabricate(:seeker,
              email: 'rolf@example.com',
              password: 'tester1234',
              password_confirmation: 'tester1234',
              place: region.places.first)
  end

  background do
    login_as(user, scope: :seeker)
  end

  scenario 'Successfully log out' do
    visit_on region, '/seeker/dashboard'
    click_on 'Abmelden'

    within_notifications do
      expect(page).to have_content('Erfolgreich abgemeldet.')
    end
  end
end
