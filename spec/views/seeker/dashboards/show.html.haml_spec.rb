require 'spec_helper'

describe 'seeker/dashboards/show.html.haml' do
  it 'contains the link to show all jobs' do
    render
    expect(rendered).to have_link('Alle Jobs in der Region anzeigen', seeker_jobs_path)
  end
end
