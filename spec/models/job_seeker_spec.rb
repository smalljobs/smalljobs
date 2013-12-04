require 'spec_helper'

describe JobSeeker do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:job_seeker)).to be_valid
    end
  end

  describe '#firstname' do
    it 'is not valid without a firstname' do
      expect(Fabricate.build(:job_seeker, firstname: nil)).not_to be_valid
    end
  end

  describe '#lastname' do
    it 'is not valid without a lastname' do
      expect(Fabricate.build(:job_seeker, lastname: nil)).not_to be_valid
    end
  end

  describe '#street' do
    it 'is not valid without a street' do
      expect(Fabricate.build(:job_seeker, street: nil)).not_to be_valid
    end
  end

  describe '#zip' do
    it 'is not valid without a zip' do
      expect(Fabricate.build(:job_seeker, zip: nil)).not_to be_valid
    end

    it 'must conform to Swiss zip format' do
      expect(Fabricate.build(:job_seeker, zip: '123a')).not_to be_valid
      expect(Fabricate.build(:job_seeker, zip: '123')).not_to be_valid
      expect(Fabricate.build(:job_seeker, zip: '12345')).not_to be_valid
      expect(Fabricate.build(:job_seeker, zip: '1')).not_to be_valid

      expect(Fabricate.build(:job_seeker, zip: '1234')).to be_valid
    end
  end

  describe '#city' do
    it 'is not valid without a city' do
      expect(Fabricate.build(:job_seeker, city: nil)).not_to be_valid
    end
  end

  describe '#email' do
    it 'is not valid without a email' do
      expect(Fabricate.build(:job_seeker, email: nil)).not_to be_valid
    end

    it 'must be a valid email' do
      expect(Fabricate.build(:job_seeker, email: 'michinetz.ch')).not_to be_valid
      expect(Fabricate.build(:job_seeker, email: 'michi@netzpiraten.ch')).to be_valid
    end
  end

  describe '#phone' do
    it 'should be a plausible phone number' do
      expect(Fabricate.build(:job_seeker, phone: 'abc123')).not_to be_valid
      expect(Fabricate.build(:job_seeker, phone: '056 496 03 58')).to be_valid
    end

    it 'normalizes the phone number' do
      expect(Fabricate(:job_seeker, phone: '056 496 03 58').phone).to eql('41564960358')
    end
  end

  describe '#mobile' do
    it 'should be a plausible phone number' do
      expect(Fabricate.build(:job_seeker, phone: 'abc123')).not_to be_valid
      expect(Fabricate.build(:job_seeker, phone: '079 244 55 61')).to be_valid
    end

    it 'normalizes the phone number' do
      expect(Fabricate(:job_seeker, phone: "079/244'55'61").phone).to eql('41792445561')
    end
  end

  describe '#date_of_birth' do
    it 'ensures the seeker is at least of age 13' do
      expect(Fabricate.build(:job_seeker, date_of_birth: 12.years.ago)).not_to be_valid
      expect(Fabricate.build(:job_seeker, date_of_birth: 13.years.ago)).to be_valid
    end

    it 'ensures the seeker is at max of age 18' do
      expect(Fabricate.build(:job_seeker, date_of_birth: 18.years.ago)).to be_valid
      expect(Fabricate.build(:job_seeker, date_of_birth: 19.years.ago)).not_to be_valid
    end
  end

  describe '#active' do
    it 'is active by default' do
      expect(Fabricate(:job_seeker)).to be_active
    end
  end

  describe '#contact_preference' do
    it 'must be one of email, phone, mobile or postal' do
      expect(Fabricate.build(:job_seeker, contact_preference: 'abc123')).not_to be_valid
      expect(Fabricate.build(:job_seeker, contact_preference: 'email')).to be_valid
      expect(Fabricate.build(:job_seeker, contact_preference: 'mobile')).to be_valid
      expect(Fabricate.build(:job_seeker, contact_preference: 'phone')).to be_valid
      expect(Fabricate.build(:job_seeker, contact_preference: 'postal')).to be_valid
    end
  end

  describe '#contact_availability' do
    it 'is not necessary for email, postal and whatsapp' do
      expect(Fabricate.build(:job_seeker, contact_preference: 'email', contact_availability: nil)).to be_valid
      expect(Fabricate.build(:job_seeker, contact_preference: 'postal', contact_availability: nil)).to be_valid
      expect(Fabricate.build(:job_seeker, contact_preference: 'whatsapp', contact_availability: nil)).to be_valid
    end

    it 'is necessary for phone and mobile' do
      expect(Fabricate.build(:job_seeker, contact_preference: 'phone', contact_availability: nil)).not_to be_valid
      expect(Fabricate.build(:job_seeker, contact_preference: 'mobile', contact_availability: nil)).not_to be_valid
    end
  end

  describe '#work_categories' do
    it 'needs at least one selection' do
      expect(Fabricate.build(:job_seeker, work_categories: [])).not_to be_valid
    end
  end

  describe "#name" do
    it 'uses the first and last as name' do
      expect(Fabricate(:job_seeker, firstname: 'Otto', lastname: 'Biber').name).to eql('Otto Biber')
    end
  end
end
