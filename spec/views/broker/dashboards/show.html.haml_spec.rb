require 'spec_helper'

describe 'broker/dashboards/show.html.haml' do
  it 'contains the link to show all provider' do
    render
    expect(rendered).to have_link('Alle Anbieter anzeigen', broker_providers_path)
  end

  it 'contains the link to show all seekers' do
    render
    expect(rendered).to have_link('Alle Sucher anzeigen', broker_seekers_path)
  end

  it 'contains the link to show all jobs' do
    render
    expect(rendered).to have_link('Alle Jobs anzeigen', broker_jobs_path)
  end
end
