# coding: UTF-8

require_relative '../spec_helper'
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

    it 'can manage its organizations' do
      expect(ability).to be_able_to(:manage, Organization)
    end

    it 'cannot read other organizations' do
      expect(ability).to_not be_able_to(:read, Fabricate(:organization, place: Fabricate(:place, zip: '9999')))
    end

    it 'can manage all providers' do
      expect(ability).to be_able_to(:manage, Provider)
    end

    it 'cannot read providers not in his region' do
      expect(ability).to_not be_able_to(:read, Fabricate(:provider, place: Fabricate(:place, zip: '9999')))
    end

    it 'can manage all seekers' do
      expect(ability).to be_able_to(:manage, Seeker)
    end

    it 'cannot read seekers not in his region' do
      expect(ability).to_not be_able_to(:read, Fabricate(:seeker, place: Fabricate(:place, zip: '9999')))
    end

    it 'can manage all jobs' do
      expect(ability).to be_able_to(:manage, Job)
    end

    it 'can activate jobs' do
      expect(ability).to be_able_to(:activate, Job)
    end

    it 'cannot activate jobs not in his region' do
      expect(ability).to_not be_able_to(:activate, Fabricate(:job, provider: Fabricate(:provider, place: Fabricate(:place, zip: '9999'))))
    end

    it 'cannot read jobs not in his region' do
      expect(ability).to_not be_able_to(:read, Fabricate(:job, provider: Fabricate(:provider, place: Fabricate(:place, zip: '9999'))))
    end

    it 'can manage all allocations' do
      expect(ability).to be_able_to(:manage, Allocation)
    end

    it 'cannot read allocations not in his region' do
      expect(ability).to_not be_able_to(:read, Fabricate(:allocation, job: Fabricate(:job, provider: Fabricate(:provider, place: Fabricate(:place, zip: '9999')))))
    end
  end

  context 'for a provider' do
    let(:user) { Fabricate(:provider) }
    let(:ability) { Ability.new(user) }

    it 'can manage his jobs' do
      expect(ability).to be_able_to(:manage, Fabricate(:job, provider: user))
    end

    it 'cannot manage other providers jobs' do
      expect(ability).to_not be_able_to(:manage, Fabricate(:job))
    end

    it 'can read his allocations' do
      expect(ability).to be_able_to(:read, Fabricate(:allocation, job: Fabricate(:job, provider: user)))
    end

    it 'cannot read other providers allocations' do
      expect(ability).to_not be_able_to(:read, Fabricate(:allocation))
    end
  end

  context 'for a seeker' do
    let(:user) { Fabricate(:seeker) }
    let(:ability) { Ability.new(user) }

    it 'can read jobs in his region' do
      expect(ability).to be_able_to(:read, Fabricate(:job, provider: Fabricate(:provider, place: user.place)))
    end

    it 'cannot read jobs in other regions' do
      expect(ability).to_not be_able_to(:read, Fabricate(:job))
    end

    it 'can read his allocations' do
      expect(ability).to be_able_to(:read, Fabricate(:allocation, seeker: user))
    end
  end
end
