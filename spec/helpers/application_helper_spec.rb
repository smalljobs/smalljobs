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

  describe '#provider_status_class' do
    it 'maps an unconfirmed provider to the warning class' do
      provider = Fabricate(:provider, confirmed: false, active: false)
      expect(helper.provider_status_class(provider)).to eq('warning')
    end

    it 'maps an confirmed, inactive provider to the danger class' do
      provider = Fabricate(:provider, confirmed: true, active: false)
      expect(helper.provider_status_class(provider)).to eq('danger')
    end

    it 'maps an confirmed, active provider to no class' do
      provider = Fabricate(:provider, confirmed: true, active: true)
      expect(helper.provider_status_class(provider)).to eq('')
    end
  end

  describe '#provider_label' do
    it 'labels an unconfirmed provider' do
      provider = Fabricate(:provider, confirmed: false, active: false)
      expect(helper.provider_label(provider)).to eq('<span class="label label-warning">Unbestätigt</span>')
    end

    it 'labels an confirmed, inactive providern' do
      provider = Fabricate(:provider, confirmed: true, active: false)
      expect(helper.provider_label(provider)).to eq('<span class="label label-danger">Inaktiv</span>')
    end

    it 'labels an confirmed, active provider' do
      provider = Fabricate(:provider, confirmed: true, active: true)
      expect(helper.provider_label(provider)).to eq('<span class="label label-success">Aktiv</span>')
    end
  end

  describe '#bootstrap_label' do
    it 'creates a bootstrap span label' do
      expect(helper.bootstrap_label('kind', 'text')).to eq('<span class="label label-kind">text</span>')
    end
  end

end
