require 'spec_helper'

describe 'provider/dashboards/show.html.haml' do
  it 'contains the link to show all his jobs' do
    render
    expect(rendered).to have_link('Alle ihre Jobs anzeigen', provider_jobs_path)
  end
end
