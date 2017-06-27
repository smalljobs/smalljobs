require 'spec_helper'
require 'carrierwave/test/matchers'

describe LogoUploader do
  include CarrierWave::Test::Matchers

  let(:organization) { Fabricate(:organization, id: 123) }
  let(:uploader)    { LogoUploader.new(organization, :logo) }

  describe '#store_dir' do
    it 'provides a unique path for the model' do
      expect(uploader.store_dir).to eql('uploads/organization/logo/123')
    end
  end

end
