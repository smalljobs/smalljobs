require_relative '../spec_helper'

describe ConfirmationsController, type: :controller do
  describe '#after_resending_confirmation_instructions_path_for' do
    it 'returns the root path' do
      expect(controller.send(:after_resending_confirmation_instructions_path_for, :provider)).to eql('/')
    end
  end

  describe '#after_confirmation_path_for' do
    it 'returns the root path' do
      expect(controller.send(:after_confirmation_path_for, :provider, Fabricate(:provider))).to eql('/')
    end
  end
end
