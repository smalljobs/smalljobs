require 'spec_helper'

describe JobProvider do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:job_provider)).to be_valid
    end
  end

  describe '#username' do
    it 'is not valid without a username' do
      expect(Fabricate.build(:job_provider, username: nil)).not_to be_valid
    end

    it 'must be a unique name' do
      Fabricate(:job_provider, username: 'Yo Land')
      expect(Fabricate.build(:job_provider, username: 'Yo Land')).not_to be_valid
    end
  end

  describe '#firstname' do
    it 'is not valid without a firstname' do
      expect(Fabricate.build(:job_provider, firstname: nil)).not_to be_valid
    end
  end

  describe '#lastname' do
    it 'is not valid without a lastname' do
      expect(Fabricate.build(:job_provider, lastname: nil)).not_to be_valid
    end
  end

  describe '#street' do
    it 'is not valid without a street' do
      expect(Fabricate.build(:job_provider, street: nil)).not_to be_valid
    end
  end

  describe '#zip' do
    it 'is not valid without a zip' do
      expect(Fabricate.build(:job_provider, zip: nil)).not_to be_valid
    end

    it 'must conform to Swiss zip format' do
      expect(Fabricate.build(:job_provider, zip: '123a')).not_to be_valid
      expect(Fabricate.build(:job_provider, zip: '123')).not_to be_valid
      expect(Fabricate.build(:job_provider, zip: '12345')).not_to be_valid
      expect(Fabricate.build(:job_provider, zip: '1')).not_to be_valid

      expect(Fabricate.build(:job_provider, zip: '1234')).to be_valid
    end
  end

  describe '#city' do
    it 'is not valid without a city' do
      expect(Fabricate.build(:job_provider, city: nil)).not_to be_valid
    end
  end

  describe '#email' do
    it 'must be a valid email' do
      expect(Fabricate.build(:job_provider, email: 'michinetz.ch')).not_to be_valid
      expect(Fabricate.build(:job_provider, email: 'michi@netzpiraten.ch')).to be_valid
    end
  end

  describe '#phone' do
    it 'should be a plausible phone number' do
      expect(Fabricate.build(:job_provider, phone: 'abc123')).not_to be_valid
      expect(Fabricate.build(:job_provider, phone: '056 496 03 58')).to be_valid
    end

    it 'normalizes the phone number' do
      expect(Fabricate(:job_provider, phone: '056 496 03 58').phone).to eql('41564960358')
    end
  end

  describe '#mobile' do
    it 'should be a plausible phone number' do
      expect(Fabricate.build(:job_provider, phone: 'abc123')).not_to be_valid
      expect(Fabricate.build(:job_provider, phone: '079 244 55 61')).to be_valid
    end

    it 'normalizes the phone number' do
      expect(Fabricate(:job_provider, phone: "079/244'55'61").phone).to eql('41792445561')
    end
  end

  describe '#active' do
    it 'is active by default' do
      expect(Fabricate(:job_provider)).to be_active
    end
  end

  describe '#contact_preference' do
    it 'must be one of email, phone, mobile or postal' do
      expect(Fabricate.build(:job_provider, contact_preference: 'abc123')).not_to be_valid
      expect(Fabricate.build(:job_provider, contact_preference: 'email')).to be_valid
      expect(Fabricate.build(:job_provider, contact_preference: 'mobile')).to be_valid
      expect(Fabricate.build(:job_provider, contact_preference: 'phone')).to be_valid
      expect(Fabricate.build(:job_provider, contact_preference: 'postal')).to be_valid
    end
  end

  describe '#contact_availability' do
    it 'is not necessary for email and postal' do
      expect(Fabricate.build(:job_provider, contact_preference: 'email', contact_availability: nil)).to be_valid
      expect(Fabricate.build(:job_provider, contact_preference: 'postal', contact_availability: nil)).to be_valid
    end

    it 'is necessary for phone and mobile' do
      expect(Fabricate.build(:job_provider, contact_preference: 'phone', contact_availability: nil)).not_to be_valid
      expect(Fabricate.build(:job_provider, contact_preference: 'mobile', contact_availability: nil)).not_to be_valid
    end
  end

  describe "#name" do
    it 'uses the first and last as name' do
      expect(Fabricate(:job_provider, firstname: 'Otto', lastname: 'Biber').name).to eql('Otto Biber')
    end
  end
end
