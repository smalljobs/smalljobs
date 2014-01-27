require 'spec_helper'

describe MailerHelper do

  describe '#subdomain_for' do
    let(:region) { Fabricate(:region_bremgarten) }

    context 'for a broker' do
      let(:employment) { Fabricate(:employment, region: region) }
      let(:broker) { Fabricate(:broker, employments: [employment]) }

      it 'returns the first region subdomain' do
        expect(helper.subdomain_for(broker)).to eql('bremgarten')
      end
    end

    context 'for a provider' do
      let(:provider) { Fabricate(:provider, place: region.places.first) }

      it 'returns the provider region subdomain' do
        expect(helper.subdomain_for(provider)).to eql('bremgarten')
      end
    end

    context 'for a seeker' do
      let(:seeker) { Fabricate(:seeker, place: region.places.last) }

      it 'returns the seeker region subdomain' do
        expect(helper.subdomain_for(seeker)).to eql('bremgarten')
      end
    end
  end

end
