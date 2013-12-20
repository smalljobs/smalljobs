require 'spec_helper'

describe ApplicationHelper do

  describe '#provider_contact_preferences' do
    it 'returns the translated contact preferences for job providers' do
      expect(helper.provider_contact_preferences).to eq([
        ['Per Post', 'postal'],
        ['Telefon', 'phone'],
        ['Email', 'email'],
        ['Mobiltelefon', 'mobile']
      ])
    end
  end

  describe '#seeker_contact_preferences' do
    it 'returns the translated contact preferences for job seekers' do
      expect(helper.seeker_contact_preferences).to eq([
        ['WhatsApp', 'whatsapp'],
        ['Mobiltelefon', 'mobile'],
        ['Email', 'email'],
        ['Telefon', 'phone']
      ])
    end
  end

  describe '#flash_class' do
    it 'maps a notice to an info alert' do
      expect(helper.flash_class(:notice)).to eq('alert-info')
    end

    it 'maps an error to an error alert' do
      expect(helper.flash_class(:error)).to eq('alert-error')
    end

    it 'maps an alert to a warning alert' do
      expect(helper.flash_class(:alert)).to eq('alert-warning')
    end
  end

end
