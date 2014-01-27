require 'spec_helper'

describe 'broker/providers/edit.html.haml' do

  let(:region) { Fabricate(:region) }
  let(:provider) { Fabricate(:provider, place: region.places.first) }

  before do
    assign(:provider, provider)
    view.stub(current_region: region)
    render
  end

  context 'form elements' do
    it 'renders the login input' do
      expect(rendered).to have_field('Benutzername', with: provider.username)
      expect(rendered).to have_field('Passwort')
      expect(rendered).to have_field('Passwortbestätigung')
    end

    it 'renders the address inputs' do
      expect(rendered).to have_field('Vorname', with: provider.firstname)
      expect(rendered).to have_field('Nachname', with: provider.lastname)
      expect(rendered).to have_field('Strasse', with: provider.street)
      expect(rendered).to have_select('Ort', selected: provider.place.name)
    end

    it 'renders the contact inputs' do
      expect(rendered).to have_field('Email', with: provider.email)
      expect(rendered).to have_field('Telefon', with: provider.phone)
      expect(rendered).to have_field('Mobile', with: provider.mobile)
      expect(rendered).to have_field('Bevorzuge Kontaktart', with: provider.contact_preference)
      expect(rendered).to have_field('Am Besten zu Erreichen', with: provider.contact_availability)
    end

    context 'form actions' do
      it 'renders the update button' do
        expect(rendered).to have_button('Bearbeiten')
      end
    end
  end

  context 'global actions' do
    it 'contains the link to show the provider' do
      expect(rendered).to have_link('Anzeigen', broker_provider_path(provider))
    end

    it 'contains the link to the providers list' do
      expect(rendered).to have_link('Zurück', broker_providers_path)
    end
  end
end
