require 'spec_helper'

describe Employment do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:job_broker)).to be_valid
    end
  end
end
