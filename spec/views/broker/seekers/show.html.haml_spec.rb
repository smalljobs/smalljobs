require 'spec_helper'

describe 'broker/seekers/show.html.haml' do

  let(:region) { Fabricate(:region) }

  let(:category_1) { Fabricate(:work_category, name: 'Putzen')}
  let(:category_2) { Fabricate(:work_category, name: 'Rasen')}

  let(:seeker) { Fabricate(:seeker,
                           date_of_birth: Date.new(1999, 1, 1),
                           place: region.places.first,
                           work_categories: [category_1, category_2]) }

  before do
    assign(:seeker, seeker)
    view.stub(current_region: region)
    render
  end

  it 'shows the seeker name' do
    expect(rendered).to have_text(seeker.name)
  end

  it 'shows the seeker street' do
    expect(rendered).to have_text(seeker.street)
  end

  it 'shows the seeker zip' do
    expect(rendered).to have_text(seeker.place.zip)
  end

  it 'shows the seeker city' do
    expect(rendered).to have_text(seeker.place.name)
  end

  it 'shows the seeker date of birth' do
    expect(rendered).to have_text('1. Januar 1999')
  end

  it 'shows the seeker phone' do
    expect(rendered).to have_text(seeker.phone.phony_formatted)
  end

  it 'shows the seeker mobile' do
    expect(rendered).to have_text(seeker.mobile.phony_formatted)
  end

  it 'shows the seeker email' do
    expect(rendered).to have_text(seeker.email)
  end

  it 'shows the work categories' do
    expect(rendered).to have_text('Putzen')
    expect(rendered).to have_text('Rasen')
  end

  context 'global actions' do
    it 'contains the link to edit the seeker' do
      expect(rendered).to have_link('Bearbeiten', edit_broker_seeker_path(seeker))
    end

    it 'contains the link to the seekers list' do
      expect(rendered).to have_link('Zurück', broker_seekers_path)
    end
  end
end
