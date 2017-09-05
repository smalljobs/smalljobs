require_relative '../spec_helper'

describe ApplicationHelper, type: :helper do

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

  describe '#seeker_sex' do
    it 'returns the translated sex for job seekers' do
      expect(helper.seeker_sex).to eq([
        ['Männlich', 'male'],
        ['Weiblich', 'female'],
        ['Anderes', 'other']
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

  describe '#seeker_contact_preferences' do
    it 'returns the translated contact preferences for job seekers' do
      expect(helper.job_date_types).to eq([
        ['Nach Absprache', 'agreement'],
        ['An einem bestimmten Tag', 'date'],
        ['In einem bestimmten Zeitraum', 'date_range'],
      ])
    end
  end

  describe '#seeker_contact_preferences' do
    it 'returns the translated contact preferences for job seekers' do
      expect(helper.job_salary_types).to eq([
        ['Stundenlohn pro Altersjahr', 'hourly_per_age'],
        ['Stundenlohn', 'hourly'],
        ['Fixer Preis', 'fixed']
      ])
    end
  end

  describe '#flash_class' do
    it 'maps a notice to an info alert' do
      expect(helper.flash_class(:notice)).to eq('alert-info')
    end

    it 'maps an error to an error alert' do
      expect(helper.flash_class(:error)).to eq('alert-danger')
    end

    it 'maps an alert to a warning alert' do
      expect(helper.flash_class(:alert)).to eq('alert-warning')
    end
  end

  describe '#provider_status_class' do
    it 'maps an unconfirmed provider to the warning class' do
      provider = Fabricate(:provider, active: false)
      expect(helper.provider_status_class(provider)).to eq('')
    end

    it 'maps an confirmed, inactive provider to the danger class' do
      provider = Fabricate(:provider, active: false)
      expect(helper.provider_status_class(provider)).to eq('')
    end

    it 'maps an confirmed, active provider to no class' do
      provider = Fabricate(:provider, active: true)
      expect(helper.provider_status_class(provider)).to eq('')
    end
  end

  describe '#job_status_class' do
    it 'maps an job without seekers to the warning class' do
      job = Fabricate(:job)
      expect(helper.job_status_class(job)).to eq('warning')
    end
  end

  describe '#provider_label' do
    it 'labels an unconfirmed provider' do
      provider = Fabricate(:provider, active: false)
      expect(helper.provider_label(provider)).to eq('<span class="label label-success">Aktiv</span>')
    end

    it 'labels an confirmed, inactive provider' do
      provider = Fabricate(:provider, active: false)
      expect(helper.provider_label(provider)).to eq('<span class="label label-success">Aktiv</span>')
    end

    it 'labels an confirmed, active provider' do
      provider = Fabricate(:provider, active: true)
      expect(helper.provider_label(provider)).to eq('<span class="label label-success">Aktiv</span>')
    end
  end

  describe '#bootstrap_label' do
    it 'creates a bootstrap span label' do
      expect(helper.bootstrap_label('kind', 'text')).to eq('<span class="label label-kind">text</span>')
    end
  end

  describe '#current_filter_class' do
    context 'without request params' do
      context 'without filter' do
        it 'returns a class' do
          expect(helper.current_filter_class).to eql('active')
        end
      end

      context 'with filter' do
        it 'does not return a class' do
          expect(helper.current_filter_class('filter_param')).to be_nil
        end
      end
    end

    context 'with request param' do
      before do
        helper.stub(:params) { { filter_param: true }.with_indifferent_access }
      end

      context 'without filter' do
        it 'returns a class' do
          expect(helper.current_filter_class).to be_nil
        end
      end

      context 'with filter' do
        it 'does not return a class' do
          expect(helper.current_filter_class('filter_param')).to eql('active')
        end
      end
    end
  end
end
