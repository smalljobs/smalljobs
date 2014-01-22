require 'spec_helper'

describe 'broker/seekers/edit.html.haml' do

  let(:seeker) { Fabricate(:seeker) }

  before do
    assign(:seeker, seeker)
    render
  end

  context 'form elements' do
    it 'renders the login input' do
      expect(rendered).to have_field('Email', with: seeker.email)
      expect(rendered).to have_field('Passwort')
      expect(rendered).to have_field('Passwortbestätigung')
    end

    it 'renders the address inputs' do
      expect(rendered).to have_field('Vorname', with: seeker.firstname)
      expect(rendered).to have_field('Nachname', with: seeker.lastname)
      expect(rendered).to have_field('Strasse', with: seeker.street)
      expect(rendered).to have_field('PLZ', with: seeker.zip)
      expect(rendered).to have_field('Ort', with: seeker.city)
    end

    it 'renders the contact inputs' do
      expect(rendered).to have_field('Telefon', with: seeker.phone)
      expect(rendered).to have_field('Mobile', with: seeker.mobile)
      expect(rendered).to have_field('Bevorzuge Kontaktart', with: seeker.contact_preference)
      expect(rendered).to have_field('Am Besten zu Erreichen', with: seeker.contact_availability)
    end

    context 'form actions' do
      it 'renders the update button' do
        expect(rendered).to have_button('Bearbeiten')
      end
    end
  end

  context 'global actions' do
    it 'contains the link to show the seeker' do
      expect(rendered).to have_link('Anzeigen', broker_seeker_path(seeker))
    end

    it 'contains the link to the seekers list' do
      expect(rendered).to have_link('Zurück', broker_seekers_path)
    end
  end
end
