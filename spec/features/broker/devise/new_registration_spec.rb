# coding: UTF-8

require 'spec_helper'

feature 'New job broker registration' do
  let(:region) { Fabricate(:region, name: 'Bremgarten') }

  scenario 'public registrations' do
    visit_on region, '/brokers/sign_up'

    within_notifications do
      expect(page).to have_content('Sie können sich nicht selber als Anbieter registrieren. Bitte kontaktieren Sie uns unter hello@smalljobs.ch')
    end

    expect(current_path).to eql('/')
  end

end
