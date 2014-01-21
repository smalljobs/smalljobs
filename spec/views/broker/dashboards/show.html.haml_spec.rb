require 'spec_helper'

describe 'broker/dashboards/show.html.haml' do
  it 'contains the link to show all provider' do
    render
    expect(rendered).to have_link('Alle Anbieter anzeigen', broker_providers_path)
  end
end
