require 'spec_helper'

describe 'regions/index.html.haml' do
  before do
    Fabricate(:org_bremgarten)
    Fabricate(:org_lenzburg)
    assign(:organizations, Organization.all)
    render
  end

  it 'shows the supported organization names' do
    expect(rendered).to have_text('Jugendarbeit Bremgarten')
    expect(rendered).to have_text('Jugendarbeit Lenzburg')
  end

  it 'shows the supported regions' do
    expect(rendered).to have_text('Region Bremgarten')
    expect(rendered).to have_text('Region Lenzburg')
  end

  it 'shows the supported places' do
    expect(rendered).to have_text('Bremgarten')
    expect(rendered).to have_text('Zufikon')
    expect(rendered).to have_text('Wohlen')

    expect(rendered).to have_text('Niederlenz')
    expect(rendered).to have_text('Boniswil')
    expect(rendered).to have_text('Egliswil')
    expect(rendered).to have_text('Seon')
    expect(rendered).to have_text('Lenzburg')
  end

  it 'links to all region subdomains' do
    expect(rendered).to match(root_url(subdomain: 'bremgarten'))
    expect(rendered).to match(root_url(subdomain: 'lenzburg'))
  end
end
