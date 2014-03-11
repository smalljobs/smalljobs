require 'spec_helper'

describe 'pages/terms_of_service.html.haml' do
  context 'for a HTTP request' do
    before do
      view.request.stub(xhr?: false)
      render
    end

    it 'does not contain the modal markup' do
      expect(rendered).not_to include('modal-header')
      expect(rendered).not_to include('modal-body')
      expect(rendered).not_to include('modal-footer')
    end
  end

  context 'for a AJAX request' do
    before do
      view.request.stub(xhr?: true)
      render
    end

    it 'does contain the modal markup' do
      expect(rendered).to include('modal-header')
      expect(rendered).to include('modal-body')
      expect(rendered).to include('modal-footer')
    end
  end

end
