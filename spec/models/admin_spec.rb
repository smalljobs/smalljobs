require 'spec_helper'

describe Admin do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:admin)).to be_valid
    end
  end

  describe "#name" do
    it 'uses the email as name' do
      expect(Fabricate(:admin, email: 'test@example.com').name).to eql('test@example.com')
    end
  end
end
