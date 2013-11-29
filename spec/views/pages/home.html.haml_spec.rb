require 'spec_helper'

describe "pages/home.html.haml" do
  it 'contains the link to the job provider sign up' do
    render
    expect(rendered).to match(new_job_provider_registration_path)
  end

  it 'contains the link to the job seeker sign up' do
    render
    expect(rendered).to match(new_job_seeker_registration_path)
  end
end
