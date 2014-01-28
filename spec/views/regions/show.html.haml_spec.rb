require 'spec_helper'

describe 'regions/show.html.haml' do
  before do
    assign(:organization, Fabricate(:org_lenzburg))
    render
  end

  it 'shows the organization name' do
    expect(rendered).to have_text('Jugendarbeit Lenzburg')
  end

  it 'shows the organization description' do
    expect(rendered).to have_text('regionale Jugendarbeit Lotten')
  end

  it 'shows the organization address' do
    expect(rendered).to have_text('c/o JA Lenzburg, Soziale Dienste')
    expect(rendered).to have_text('5600 Lenzburg')
  end

  it 'shows the organization contact info' do
    expect(rendered).to have_text('062 508 13 14')
    expect(rendered).to have_text('info@jugendarbeit-lotten.ch')
    expect(rendered).to have_text('www.jugendarbeit-lotten.ch')
  end

  it 'shows the organization places' do
    expect(rendered).to have_text('Niederlenz')
    expect(rendered).to have_text('Boniswil')
    expect(rendered).to have_text('Egliswil')
    expect(rendered).to have_text('Seon')
  end

  it 'shows the organization brokers' do
    expect(rendered).to have_text('Mich Wyser')
    expect(rendered).to have_text('062 897 01 21')
  end
end
