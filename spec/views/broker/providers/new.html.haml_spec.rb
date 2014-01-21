require 'spec_helper'

describe 'broker/providers/new.html.haml' do

  let(:provider) { Fabricate.build(:provider) }

  before do
    assign(:provider, provider)
    render
  end

  context 'form elements' do
    it 'renders the login input' do
      expect(rendered).to have_field('Benutzername')
      expect(rendered).to have_field('Passwort')
      expect(rendered).to have_field('Passwortbestätigung')
    end

    it 'renders the address inputs' do
      expect(rendered).to have_field('Vorname')
      expect(rendered).to have_field('Nachname')
      expect(rendered).to have_field('Strasse')
      expect(rendered).to have_field('PLZ')
      expect(rendered).to have_field('Ort')
    end

    it 'renders the contact inputs' do
      expect(rendered).to have_field('Email')
      expect(rendered).to have_field('Telefon')
      expect(rendered).to have_field('Mobile')
      expect(rendered).to have_field('Bevorzuge Kontaktart')
      expect(rendered).to have_field('Am Besten zu Erreichen')
    end

    context 'form actions' do
      it 'renders the create button' do
        expect(rendered).to have_button('Erstellen')
      end
    end
  end

  context 'global actions' do
    it 'contains the link to the providers list' do
      expect(rendered).to have_link('Zurück', broker_providers_path)
    end
  end
end
