require 'spec_helper'

describe 'broker/seekers/index.html.haml' do

  let(:seeker_A) { Fabricate(:seeker, firstname: 'OlA', lastname: 'HoplA') }
  let(:seeker_B) { Fabricate(:seeker, firstname: 'OlB', lastname: 'HoplB') }

  context 'with seekers' do
    before do
      assign(:seekers, [seeker_A, seeker_B])
      render
    end

    context 'list items' do
      it 'render the seeker first name' do
        expect(rendered).to have_text(seeker_A.firstname)
        expect(rendered).to have_text(seeker_B.firstname)
      end

      it 'render the seeker last name' do
        expect(rendered).to have_text(seeker_A.lastname)
        expect(rendered).to have_text(seeker_B.lastname)
      end

      it 'render the seeker zip' do
        expect(rendered).to have_text(seeker_A.place.zip)
        expect(rendered).to have_text(seeker_B.place.zip)
      end

      it 'render the seeker city' do
        expect(rendered).to have_text(seeker_A.place.name)
        expect(rendered).to have_text(seeker_B.place.name)
      end

      context 'list item data' do
        it 'contains the link to show the seekers details' do
          expect(rendered).to have_link('OlA HoplA anzeigen', href: broker_seeker_path(seeker_A))
          expect(rendered).to have_link('OlB HoplB anzeigen', href: broker_seeker_path(seeker_B))
        end

        it 'contains the link to edit the seekers details' do
          expect(rendered).to have_link('OlA HoplA bearbeiten', href: edit_broker_seeker_path(seeker_A))
          expect(rendered).to have_link('OlB HoplB bearbeiten', href: edit_broker_seeker_path(seeker_B))
        end

        it 'contains the link to destroy the seekers' do
          expect(rendered).to have_link('OlA HoplA löschen', href: broker_seeker_path(seeker_A))
          expect(rendered).to have_link('OlB HoplB löschen', href: broker_seeker_path(seeker_B))
        end
      end
    end
  end

  context 'without seekers' do
    before do
      assign(:seekers, [])
      render
    end

    it 'shows a message that no seekers are found' do
      expect(rendered).to have_text('Es sind noch keine Sucher in deiner Region erfasst')
    end
  end

  context 'global actions' do
    before do
      assign(:seekers, [])
      render
    end

    it 'contains the link to add a new seeker' do
      expect(rendered).to have_link('Neuen Sucher hinzufügen', new_seeker_registration_path)
    end
  end
end
