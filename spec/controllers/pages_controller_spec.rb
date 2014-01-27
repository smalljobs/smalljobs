require 'spec_helper'

describe PagesController do

  describe "GET 'join_us'" do
    it "returns http success" do
      get 'join_us'
      response.should be_success
    end
  end

  describe "GET 'sign_in'" do
    it "returns http success" do
      get 'sign_in'
      response.should be_success
    end
  end

  describe "GET 'about_us'" do
    it "returns http success" do
      get 'about_us'
      response.should be_success
    end
  end

  describe "GET 'privacy_policy'" do
    it "returns http success" do
      get 'privacy_policy'
      response.should be_success
    end
  end

  describe "GET 'terms_of_service'" do
    it "returns http success" do
      get 'terms_of_service'
      response.should be_success
    end
  end
end
