require 'spec_helper'

describe PagesController do

  describe "GET 'join_us'" do
    it "returns http success" do
      get 'join_us'
      expect(response).to be_success
    end
  end

  describe "GET 'sign_in'" do
    it "returns http success" do
      get 'sign_in'
      expect(response).to be_success
    end
  end

  describe "GET 'about_us'" do
    it "returns http success" do
      get 'about_us'
      expect(response).to be_success
    end
  end

  describe "GET 'privacy_policy'" do
    it "returns http success" do
      get 'privacy_policy'
      expect(response).to be_success
    end

    it 'renders the layout' do
      get 'privacy_policy'
      expect(response.body).to render_template('application')
    end

    context 'for a XHR request' do
      it 'does not render the layout' do
        xhr :get, 'privacy_policy'
        expect(response.body).not_to render_template('application')
      end
    end
  end

  describe "GET 'terms_of_service'" do
    it "returns http success" do
      get 'terms_of_service'
      expect(response).to be_success
    end

    it 'renders the layout' do
      get 'privacy_policy'
      expect(response.body).to render_template('application')
    end

    context 'for a XHR request' do
      it 'does not render the layout' do
        xhr :get, 'privacy_policy'
        expect(response.body).not_to render_template('application')
      end
    end
  end

  describe "GET 'rules_of_action'" do
    it "returns http success" do
      get 'rules_of_action'
      expect(response).to be_success
    end

    it 'renders the layout' do
      get 'privacy_policy'
      expect(response.body).to render_template('application')
    end

    context 'for a XHR request' do
      it 'does not render the layout' do
        xhr :get, 'privacy_policy'
        expect(response.body).not_to render_template('application')
      end
    end
  end
end
