require 'spec_helper'

describe ConfirmationsController do
  describe '#after_resending_confirmation_instructions_path_for' do
    it 'returns the root path' do
      expect(controller.send(:after_resending_confirmation_instructions_path_for, :job_provider)).to eql('/')
    end
  end

  describe '#after_confirmation_path_for' do
    it 'returns the root path' do
      expect(controller.send(:after_confirmation_path_for, :job_provider, Fabricate(:job_provider))).to eql('/')
    end
  end
end
