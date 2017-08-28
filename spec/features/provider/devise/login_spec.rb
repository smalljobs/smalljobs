# coding: UTF-8

require_relative '../../../spec_helper'

feature 'Login' do

  let(:org) { Fabricate(:org_lenzburg) }
  let(:region) { org.regions.first }

  context 'with an inactive user' do
    background do
      Fabricate(:provider,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                place: region.places.first,
                active: false)
    end

    scenario 'using valid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'

      fill_in 'E-Mail', with: 'rolf@example.com'
      fill_in 'Passwort',     with: 'tester1234'

      click_on 'Login'
    end
  end

  context 'with an active user' do
    background do
      Fabricate(:provider,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                place: region.places.first,
                active: true)
    end

    scenario 'using invalid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'

      fill_in 'E-Mail', with: 'dani'
      fill_in 'Passwort',     with: 'tester'

      click_on 'Login'

      expect(current_path).to eql('/global_sign_in')
    end

    scenario 'using valid credentials' do
      visit_on region, '/'

      click_on 'Anmelden'

      fill_in 'E-Mail', with: 'rolf@example.com'
      fill_in 'Passwort',     with: 'tester1234'

      click_on 'Login'

      expect(current_path).to eql('/provider/dashboard')
    end
  end
end
