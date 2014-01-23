# coding: UTF-8

require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  context 'for an admin' do
    let(:user) { Fabricate(:admin) }
    let(:ability) { Ability.new(user) }

    context 'Rails Admin' do
      it 'can assess rails admin' do
        expect(ability).to be_able_to(:access, :rails_admin)
      end

      it 'can manage all' do
        expect(ability).to be_able_to(:manage, :all)
      end
    end
  end

  context 'for a broker' do
    let(:user) { Fabricate(:broker_with_regions) }
    let(:ability) { Ability.new(user) }

    it 'can manage all providers' do
      expect(ability).to be_able_to(:manage, Provider)
    end

    it 'cannot read providers not in his region' do
      expect(ability).to_not be_able_to(:read, Fabricate(:provider, zip: '9999'))
    end

    it 'can manage all seekers' do
      expect(ability).to be_able_to(:manage, Seeker)
    end

    it 'cannot read seekers not in his region' do
      expect(ability).to_not be_able_to(:read, Fabricate(:seeker, zip: '9999'))
    end

    #it 'can manage all jobs' do
    #  expect(ability).to be_able_to(:manage, Job)
    #end

    #it 'cannot read jobs not in his region' do
    #  expect(ability).to_not be_able_to(:read, Fabricate(:job, provider: Fabricate(:provider, zip: '9999')))
    #end
  end
end
