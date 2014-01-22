require 'spec_helper'

describe Provider do
  context 'fabricators' do
    it 'has a valid factory' do
      expect(Fabricate(:provider)).to be_valid
    end
  end

  context 'attributes' do
    describe '#username' do
      it 'is not valid without a username' do
        expect(Fabricate.build(:provider, username: nil)).not_to be_valid
      end

      it 'must be a unique name' do
        Fabricate(:provider, username: 'Yo Land')
        expect(Fabricate.build(:provider, username: 'Yo Land')).not_to be_valid
      end
    end

    describe '#firstname' do
      it 'is not valid without a firstname' do
        expect(Fabricate.build(:provider, firstname: nil)).not_to be_valid
      end
    end

    describe '#lastname' do
      it 'is not valid without a lastname' do
        expect(Fabricate.build(:provider, lastname: nil)).not_to be_valid
      end
    end

    describe '#street' do
      it 'is not valid without a street' do
        expect(Fabricate.build(:provider, street: nil)).not_to be_valid
      end
    end

    describe '#zip' do
      it 'is not valid without a zip' do
        expect(Fabricate.build(:provider, zip: nil)).not_to be_valid
      end

      it 'must conform to Swiss zip format' do
        expect(Fabricate.build(:provider, zip: '123a')).not_to be_valid
        expect(Fabricate.build(:provider, zip: '123')).not_to be_valid
        expect(Fabricate.build(:provider, zip: '12345')).not_to be_valid
        expect(Fabricate.build(:provider, zip: '1')).not_to be_valid

        expect(Fabricate.build(:provider, zip: '1234')).to be_valid
      end
    end

    describe '#city' do
      it 'is not valid without a city' do
        expect(Fabricate.build(:provider, city: nil)).not_to be_valid
      end
    end

    describe '#email' do
      it 'must be a valid email' do
        expect(Fabricate.build(:provider, email: 'michinetz.ch')).not_to be_valid
        expect(Fabricate.build(:provider, email: 'michi@netzpiraten.ch')).to be_valid
      end
    end

    describe '#phone' do
      it 'should be a plausible phone number' do
        expect(Fabricate.build(:provider, phone: 'abc123')).not_to be_valid
        expect(Fabricate.build(:provider, phone: '056 496 03 58')).to be_valid
      end

      it 'normalizes the phone number' do
        expect(Fabricate(:provider, phone: '056 496 03 58').phone).to eql('41564960358')
      end
    end

    describe '#mobile' do
      it 'should be a plausible phone number' do
        expect(Fabricate.build(:provider, phone: 'abc123')).not_to be_valid
        expect(Fabricate.build(:provider, phone: '079 244 55 61')).to be_valid
      end

      it 'normalizes the phone number' do
        expect(Fabricate(:provider, phone: "079/244'55'61").phone).to eql('41792445561')
      end
    end

    describe '#active' do
      it 'is active by default' do
        expect(Fabricate(:provider)).to be_active
      end
    end

    describe '#contact_preference' do
      it 'must be one of email, phone, mobile or postal' do
        expect(Fabricate.build(:provider, contact_preference: 'abc123')).not_to be_valid
        expect(Fabricate.build(:provider, contact_preference: 'email')).to be_valid
        expect(Fabricate.build(:provider, contact_preference: 'mobile')).to be_valid
        expect(Fabricate.build(:provider, contact_preference: 'phone')).to be_valid
        expect(Fabricate.build(:provider, contact_preference: 'postal')).to be_valid
      end
    end

    describe '#contact_availability' do
      it 'is not necessary for email and postal' do
        expect(Fabricate.build(:provider, contact_preference: 'email', contact_availability: nil)).to be_valid
        expect(Fabricate.build(:provider, contact_preference: 'postal', contact_availability: nil)).to be_valid
      end

      it 'is necessary for phone and mobile' do
        expect(Fabricate.build(:provider, contact_preference: 'phone', contact_availability: nil)).not_to be_valid
        expect(Fabricate.build(:provider, contact_preference: 'mobile', contact_availability: nil)).not_to be_valid
      end
    end
  end

  describe '#confirmed=' do
    context 'when not confirmed' do
      let(:provider) { Fabricate(:provider, confirmed: false) }

      it 'confirms the user when set to 1' do
        expect(provider.confirmed?).to be_false
        provider.confirmed = 1
        expect(provider.confirmed?).to be_true
      end
    end

    context 'when already confirmed' do
      let(:provider) { Fabricate(:provider, confirmed: true) }

      it 'unconfirms the user when set to 0' do
        expect(provider.confirmed?).to be_true
        provider.confirmed = 0
        expect(provider.confirmed?).to be_false
      end
    end
  end

  describe '#email_required?' do
    it 'does not require an email' do
      expect(Fabricate(:provider).email_required?).to be_false
    end
  end

  describe '#unauthenticated_message' do
    context 'when confirmed' do
      it 'is inactive' do
        expect(Fabricate(:provider, confirmed: true).unauthenticated_message).to eql(:inactive)
      end
    end

    context 'when unconfirmed' do
      it 'is unconfirmed' do
        expect(Fabricate(:provider, confirmed: false).unauthenticated_message).to eql(:unconfirmed)
      end
    end
  end

  describe '#active_for_authentication?' do
    it 'is not active when not confirmed' do
      expect(Fabricate(:provider, confirmed: false, active: true).active_for_authentication?).to be_false
    end

    it 'is not active when not activated' do
      expect(Fabricate(:provider, confirmed: true, active: false).active_for_authentication?).to be_false
    end

    it 'is active when activated and confirmed' do
      expect(Fabricate(:provider, confirmed: true, active: true).active_for_authentication?).to be_true
    end
  end

  describe '#contact_preference_enum' do
    it 'returns the list of contact strings' do
      expect(Fabricate(:provider).contact_preference_enum).to eq(%w(email phone mobile postal))
    end
  end

  describe "#name" do
    it 'uses the first and last as name' do
      expect(Fabricate(:provider, firstname: 'Otto', lastname: 'Biber').name).to eql('Otto Biber')
    end
  end

  describe '#inactive_message' do
    context 'with an email' do
      it 'is unconfirmed' do
        expect(Fabricate(:provider, confirmed: false, email: 'joe@example.com').inactive_message).to eql(:unconfirmed)
      end
    end

    context 'with an email' do
      it 'is unconfirmed' do
        expect(Fabricate(:provider, confirmed: false, email: nil).inactive_message).to eql(:unconfirmed_manual)
      end
    end
  end

end
