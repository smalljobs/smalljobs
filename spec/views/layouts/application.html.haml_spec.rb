require 'spec_helper'

describe 'layouts/application.html.haml' do
  context 'navigation' do
    it 'renders the link to the home page' do
      render
      expect(rendered).to match(root_path)
    end
  end
end
