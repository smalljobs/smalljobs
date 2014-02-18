require 'spec_helper'

describe Seeker do

  it_should_behave_like 'a confirm toggle'

  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:seeker)).to be_valid
    end
  end

  context 'attributes' do
    describe '#firstname' do
      it 'is not valid without a firstname' do
        expect(Fabricate.build(:seeker, firstname: nil)).not_to be_valid
      end
    end

    describe '#lastname' do
      it 'is not valid without a lastname' do
        expect(Fabricate.build(:seeker, lastname: nil)).not_to be_valid
      end
    end

    describe '#street' do
      it 'is not valid without a street' do
        expect(Fabricate.build(:seeker, street: nil)).not_to be_valid
      end
    end

    describe '#place' do
      it 'is not valid without a place' do
        expect(Fabricate.build(:seeker, place: nil)).not_to be_valid
      end
    end

    describe '#email' do
      it 'is not valid without a email' do
        expect(Fabricate.build(:seeker, email: nil)).not_to be_valid
      end

      it 'must be a valid email' do
        expect(Fabricate.build(:seeker, email: 'michinetz.ch')).not_to be_valid
        expect(Fabricate.build(:seeker, email: 'michi@netzpiraten.ch')).to be_valid
      end
    end

    describe '#phone' do
      it 'should be a plausible phone number' do
        expect(Fabricate.build(:seeker, phone: 'abc123')).not_to be_valid
        expect(Fabricate.build(:seeker, phone: '056 496 03 58')).to be_valid
      end

      it 'normalizes the phone number' do
        expect(Fabricate(:seeker, phone: '056 496 03 58').phone).to eql('41564960358')
      end
    end

    describe '#mobile' do
      it 'should be a plausible phone number' do
        expect(Fabricate.build(:seeker, phone: 'abc123')).not_to be_valid
        expect(Fabricate.build(:seeker, phone: '079 244 55 61')).to be_valid
      end

      it 'normalizes the phone number' do
        expect(Fabricate(:seeker, phone: "079/244'55'61").phone).to eql('41792445561')
      end
    end

    describe '#date_of_birth' do
      it 'ensures the seeker is at least of age 13' do
        expect(Fabricate.build(:seeker, date_of_birth: 12.years.ago)).not_to be_valid
        expect(Fabricate.build(:seeker, date_of_birth: 13.years.ago)).to be_valid
      end

      it 'ensures the seeker is at max of age 18' do
        expect(Fabricate.build(:seeker, date_of_birth: 18.years.ago)).to be_valid
        expect(Fabricate.build(:seeker, date_of_birth: 19.years.ago)).not_to be_valid
      end
    end

    describe '#active' do
      it 'is active by default' do
        expect(Fabricate(:seeker)).to be_active
      end
    end

    describe '#contact_preference' do
      it 'must be one of email, phone, mobile or postal' do
        expect(Fabricate.build(:seeker, contact_preference: 'abc123')).not_to be_valid
        expect(Fabricate.build(:seeker, contact_preference: 'email')).to be_valid
        expect(Fabricate.build(:seeker, contact_preference: 'mobile')).to be_valid
        expect(Fabricate.build(:seeker, contact_preference: 'phone')).to be_valid
        expect(Fabricate.build(:seeker, contact_preference: 'postal')).to be_valid
      end
    end

    describe '#contact_availability' do
      it 'is not necessary for email, postal and whatsapp' do
        expect(Fabricate.build(:seeker, contact_preference: 'email', contact_availability: nil)).to be_valid
        expect(Fabricate.build(:seeker, contact_preference: 'postal', contact_availability: nil)).to be_valid
        expect(Fabricate.build(:seeker, contact_preference: 'whatsapp', contact_availability: nil)).to be_valid
      end

      it 'is necessary for phone and mobile' do
        expect(Fabricate.build(:seeker, contact_preference: 'phone', contact_availability: nil)).not_to be_valid
        expect(Fabricate.build(:seeker, contact_preference: 'mobile', contact_availability: nil)).not_to be_valid
      end
    end

    describe '#work_categories' do
      it 'needs at least one selection' do
        expect(Fabricate.build(:seeker, work_categories: [])).not_to be_valid
      end
    end

  end

  describe '#unauthenticated_message' do
    context 'when confirmed' do
      it 'is inactive' do
        expect(Fabricate(:seeker, confirmed: true).unauthenticated_message).to eql(:inactive)
      end
    end

    context 'when unconfirmed' do
      it 'is unconfirmed' do
        expect(Fabricate(:seeker, confirmed: false).unauthenticated_message).to eql(:unconfirmed)
      end
    end
  end

  describe '#active_for_authentication?' do
    it 'is not active when not confirmed' do
      expect(Fabricate(:seeker, confirmed: false, active: true).active_for_authentication?).to be_false
    end

    it 'is not active when not activated' do
      expect(Fabricate(:seeker, confirmed: true, active: false).active_for_authentication?).to be_false
    end

    it 'is active when activated and confirmed' do
      expect(Fabricate(:seeker, confirmed: true, active: true).active_for_authentication?).to be_true
    end
  end

  describe '#contact_preference_enum' do
    it 'returns the list of contact strings' do
      expect(Fabricate(:seeker).contact_preference_enum).to eq(%w(email phone mobile postal whatsapp))
    end
  end

  describe '#name' do
    it 'uses the first and last as name' do
      expect(Fabricate(:seeker, firstname: 'Otto', lastname: 'Biber').name).to eql('Otto Biber')
    end
  end

  describe '#send_agreement_email' do
    let(:seeker) { Fabricate(:seeker, confirmed: false) }
    let(:mailer) { mock('mailer') }

    it 'sends an email when a seeker is confirmed' do
      expect(Notifier).to receive(:send_agreement_for_seeker).with(seeker).and_return mailer
      expect(mailer).to receive(:deliver)
      seeker.confirm!
    end
  end
end
