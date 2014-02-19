require 'spec_helper'

describe 'broker/organizations/edit.html.haml' do

  let(:organization) { Fabricate(:org_lenzburg) }

  before do
    assign(:organization, organization)
    view.stub(current_region: organization.regions.first)
    render
  end

  context 'form elements' do
    it 'renders the organization input' do
      expect(rendered).to have_field('Name', with: organization.name)
      expect(rendered).to have_field('Beschreibung', with: organization.description)
      expect(rendered).to have_field('Strasse', with: organization.street)
      expect(rendered).to have_select('Ort', selected: organization.place.name)
    end

    it 'renders the contact inputs' do
      expect(rendered).to have_field('Webseite', with: organization.website)
      expect(rendered).to have_field('Email', with: organization.email)
      expect(rendered).to have_field('Telefon', with: organization.phone)
    end

    it 'renders the branding inputs' do
      expect(rendered).to have_field('Logo')
      expect(rendered).to have_field('Hintergrund')
    end

    context 'form actions' do
      it 'renders the update button' do
        expect(rendered).to have_button('Bearbeiten')
      end
    end
  end

  context 'global actions' do
    it 'contains the link to go back' do
      expect(rendered).to have_link('Zurück', broker_dashboard_path)
    end
  end
end
