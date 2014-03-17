require 'spec_helper'

describe 'broker/providers/index.html.haml' do

  let(:provider_A) { Fabricate(:provider, firstname: 'OlA', lastname: 'HoplA') }
  let(:provider_B) { Fabricate(:provider, firstname: 'OlB', lastname: 'HoplB') }

  context 'with providers' do
    before do
      assign(:providers, [provider_A, provider_B])
      render
    end

    context 'list items' do
      it 'render the provider first name' do
        expect(rendered).to have_text(provider_A.firstname)
        expect(rendered).to have_text(provider_B.firstname)
      end

      it 'render the provider last name' do
        expect(rendered).to have_text(provider_A.lastname)
        expect(rendered).to have_text(provider_B.lastname)
      end

      it 'render the provider zip' do
        expect(rendered).to have_text(provider_A.place.zip)
        expect(rendered).to have_text(provider_B.place.zip)
      end

      it 'render the provider city' do
        expect(rendered).to have_text(provider_A.place.name)
        expect(rendered).to have_text(provider_B.place.name)
      end

      context 'list item data' do
        it 'contains the link to show the providers details' do
          expect(rendered).to have_link('OlA HoplA anzeigen', href: broker_provider_path(provider_A))
          expect(rendered).to have_link('OlB HoplB anzeigen', href: broker_provider_path(provider_B))
        end

        it 'contains the link to edit the providers details' do
          expect(rendered).to have_link('OlA HoplA bearbeiten', href: edit_broker_provider_path(provider_A))
          expect(rendered).to have_link('OlB HoplB bearbeiten', href: edit_broker_provider_path(provider_B))
        end

        it 'contains the link to destroy the providers' do
          expect(rendered).to have_link('OlA HoplA löschen', href: broker_provider_path(provider_A))
          expect(rendered).to have_link('OlB HoplB löschen', href: broker_provider_path(provider_B))
        end
      end
    end
  end

  context 'without providers' do
    before do
      assign(:providers, [])
      render
    end

    it 'shows a message that no providers are found' do
      expect(rendered).to have_text('Es sind noch keine Anbieter in deiner Region erfasst')
    end
  end

  context 'global actions' do
    before do
      assign(:providers, [])
      render
    end

    it 'contains the link to add a new provider' do
      expect(rendered).to have_link('Neuen Anbieter hinzufügen', new_provider_registration_path)
    end

    it 'contains the link to go back to the dashboard' do
      expect(rendered).to have_link('Zurück', broker_dashboard_path)
    end
  end
end
