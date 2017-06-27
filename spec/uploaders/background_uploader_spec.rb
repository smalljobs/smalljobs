require 'spec_helper'
require 'carrierwave/test/matchers'

describe BackgroundUploader do
  include CarrierWave::Test::Matchers

  let(:organization) { Fabricate(:organization, id: 123) }
  let(:uploader)    { BackgroundUploader.new(organization, :background) }

  describe '#store_dir' do
    it 'provides a unique path for the model' do
      expect(uploader.store_dir).to eql('uploads/organization/background/123')
    end
  end

end
