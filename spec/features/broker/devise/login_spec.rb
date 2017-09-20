# coding: UTF-8

require_relative '../../../spec_helper'

feature 'Login' do
  context 'with an unconfirmed user' do
    let(:broker) do
      Fabricate(:broker_with_regions,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                confirmed: false,
                active: false)
    end

    scenario 'using valid credentials' do
      visit_on broker, '/'

      click_on 'Anmelden'

      fill_in 'E-Mail',    with: 'rolf@example.com'
      fill_in 'Passwort', with: 'tester1234'

      click_on 'Login'

      within_notifications do
        expect(page).to have_content('Sie müssen Ihre Email bestätigen, bevor Sie fortfahren können.')
      end
    end
  end

  context 'with an inactive user' do
    let(:broker) do
      Fabricate(:broker_with_regions,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                confirmed: true,
                active: false)
    end

    scenario 'using valid credentials' do
      visit_on broker, '/'

      click_on 'Anmelden'

      fill_in 'E-Mail',    with: 'rolf@example.com'
      fill_in 'Passwort', with: 'tester1234'

      click_on 'Login'

      within_notifications do
        expect(page).to have_content('Sie müssen Ihre Email bestätigen, bevor Sie fortfahren können.')
      end
    end
  end

  context 'with an active user' do
    let(:broker) do
      Fabricate(:broker_with_regions,
                email: 'rolf@example.com',
                password: 'tester1234',
                password_confirmation: 'tester1234',
                confirmed: true,
                active: true)
    end

    scenario 'using invalid credentials' do
      visit_on broker, '/'

      click_on 'Anmelden'

      fill_in 'E-Mail',    with: 'dani@example.com'
      fill_in 'Passwort', with: 'tester'

      click_on 'Login'

      expect(current_path).to eql('/global_sign_in')
    end

    scenario 'using valid credentials' do
      visit_on broker, '/'

      click_on 'Anmelden'

      fill_in 'E-Mail',    with: 'rolf@example.com'
      fill_in 'Passwort', with: 'tester1234'

      click_on 'Login'

      expect(current_path).to eql('/broker/dashboard')
    end
  end
end
