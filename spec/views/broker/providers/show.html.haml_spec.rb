require 'spec_helper'

describe 'broker/providers/show.html.haml' do

  let(:provider) { Fabricate(:provider) }

  before do
    assign(:provider, provider)
    render
  end

  it 'shows the provider name' do
    expect(rendered).to have_text(provider.name)
  end

  it 'shows the provider street' do
    expect(rendered).to have_text(provider.street)
  end

  it 'shows the provider zip' do
    expect(rendered).to have_text(provider.zip)
  end

  it 'shows the provider city' do
    expect(rendered).to have_text(provider.city)
  end

  it 'shows the provider phone' do
    expect(rendered).to have_text(provider.phone.phony_formatted)
  end

  it 'shows the provider mobile' do
    expect(rendered).to have_text(provider.mobile.phony_formatted)
  end

  it 'shows the provider email' do
    expect(rendered).to have_text(provider.email)
  end

  context 'global actions' do
    it 'contains the link to edit the provider' do
      expect(rendered).to have_link('Bearbeiten', edit_broker_provider_path(provider))
    end

    it 'contains the link to the providers list' do
      expect(rendered).to have_link('Zurück', broker_providers_path)
    end
  end
end
