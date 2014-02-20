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

    it 'cannot read jobs not in his region' do
      expect(ability).to_not be_able_to(:read, Fabricate(:job, provider: Fabricate(:provider, place: Fabricate(:place, zip: '9999'))))
    end

    it 'can manage all proposals' do
      expect(ability).to be_able_to(:manage, Proposal)
    end

    it 'cannot read proposals not in his region' do
      expect(ability).to_not be_able_to(:read, Fabricate(:proposal, job: Fabricate(:job, provider: Fabricate(:provider, place: Fabricate(:place, zip: '9999')))))
    end

    it 'can manage all applications' do
      expect(ability).to be_able_to(:manage, Application)
    end

    it 'cannot read applications not in his region' do
      expect(ability).to_not be_able_to(:read, Fabricate(:application, job: Fabricate(:job, provider: Fabricate(:provider, place: Fabricate(:place, zip: '9999')))))
    end

    it 'can manage all allocations' do
      expect(ability).to be_able_to(:manage, Allocation)
    end

    it 'cannot read allocations not in his region' do
      expect(ability).to_not be_able_to(:read, Fabricate(:allocation, job: Fabricate(:job, provider: Fabricate(:provider, place: Fabricate(:place, zip: '9999')))))
    end

    it 'can manage all reviews' do
      expect(ability).to be_able_to(:manage, Review)
    end

    it 'cannot read reviews not in his region' do
      expect(ability).to_not be_able_to(:read, Fabricate(:review, job: Fabricate(:job, provider: Fabricate(:provider, place: Fabricate(:place, zip: '9999')))))
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

    it 'can manage his reviews' do
      expect(ability).to be_able_to(:manage, Fabricate(:review, job: Fabricate(:job, provider: user)))
    end

    it 'cannot manage other providers reviews' do
      expect(ability).to_not be_able_to(:manage, Fabricate(:review))
    end
  end

  context 'for a seeker' do
    let(:user) { Fabricate(:seeker) }
    let(:ability) { Ability.new(user) }

    it 'can read all jobs' do
      expect(ability).to be_able_to(:read, Fabricate(:job))
    end

    it 'can read his proposals' do
      expect(ability).to be_able_to(:read, Fabricate(:proposal, seeker: user))
    end

    it 'cannot read other providers proposals' do
      expect(ability).to_not be_able_to(:read, Fabricate(:proposal))
    end

    it 'can manage his applications' do
      expect(ability).to be_able_to(:manage, Fabricate(:application, seeker: user))
    end

    it 'cannot manage other providers applications' do
      expect(ability).to_not be_able_to(:manage, Fabricate(:application))
    end

    it 'can read his allocations' do
      expect(ability).to be_able_to(:read, Fabricate(:allocation, seeker: user))
    end

    it 'cannot read other providers allocations' do
      expect(ability).to_not be_able_to(:read, Fabricate(:allocation))
    end

    it 'can manage his reviews' do
      expect(ability).to be_able_to(:manage, Fabricate(:review, seeker: user))
    end

    it 'cannot manage other providers reviews' do
      expect(ability).to_not be_able_to(:manage, Fabricate(:review))
    end
  end
end
