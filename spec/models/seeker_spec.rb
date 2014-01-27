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

  describe "#name" do
    it 'uses the first and last as name' do
      expect(Fabricate(:seeker, firstname: 'Otto', lastname: 'Biber').name).to eql('Otto Biber')
    end
  end

  describe '.find_for_facebook_oauth' do
    let(:auth) do
      OpenStruct.new({
        provider: 'facebook',
        uid: '1234567890',
        info: OpenStruct.new({
          email: 'test@example.com'
        }),
        extra: OpenStruct.new({
          raw_info: OpenStruct.new({
            first_name: 'Tomas',
            last_name: 'Anderson'
          })
        })
      })
    end

    context 'without an existing job seeker' do
      let(:user) { Seeker.find_for_facebook_oauth(auth) }

      it 'uses the Facebook email' do
        expect(user.email).to eq('test@example.com')
      end

      it 'uses the Facebook first name' do
        expect(user.firstname).to eq('Tomas')
      end

      it 'uses the Facebook last name' do
        expect(user.lastname).to eq('Anderson')
      end

      it 'remembers Facebook as oauth provider' do
        expect(user.provider).to eq('facebook')
      end

      it 'remembers the oauth uid' do
        expect(user.uid).to eq('1234567890')
      end

      it 'generates a random password' do
        expect(user.encrypted_password).not_to be_empty
      end

      it 'saves saves the user without being fully valid' do
        expect(user).to be_persisted
        expect(user).not_to be_valid
      end
    end

    context 'with an exiting job seeker' do
      let(:user)  { Seeker.find_for_facebook_oauth(auth) }
      let(:other) { Fabricate(:seeker, provider: 'facebook', uid: '1234567890') }

      it 'returns the existing user' do
        expect(other).to eq(user)
      end
    end
  end

  describe '.new_with_session' do
    let(:session) do
      {
        'devise.facebook_data' => {
          'extra' => {
            'raw_info' => {
              'email' => 'test@example.com',
              'first_name' => 'Ronja',
              'last_name' => 'Rapunzel'
            }
          }
        }
      }
    end

    it 'takes the email from the oauth request' do
      expect(Seeker.new_with_session({}, session).email).to eq('test@example.com')
    end

    it 'takes the first name from the oauth request' do
      expect(Seeker.new_with_session({}, session).firstname).to eq('Ronja')
    end

    it 'takes the last name from the oauth request' do
      expect(Seeker.new_with_session({}, session).lastname).to eq('Rapunzel')
    end
  end
end
