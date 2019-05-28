class Ability
  include CanCan::Ability

  def initialize(user, region)
    if user.is_a?(Admin)
      can :access, :rails_admin
      can :manage, :all

    elsif user.is_a?(Broker)
      places = user.places.pluck(:id)

      if user.organization_admin?
        can :manage, Organization, place: { id: places }
      elsif user.region_admin?
        can :manage, Region
      end

      can :manage, Provider, place: { id: places }
      can :manage, Seeker, place: { id: places }

      can :manage, Job, provider: { place: { id: places }}
      can :manage, Job, provider: nil
      can :activate, Job, provider: { place: { id: places }}
      can :activate, Job, provider: nil

      can :manage, Allocation, job: { provider: { place: { id: places }}}

    elsif user.is_a?(Provider)
      can :manage, Job, provider: { id: user.id }

      can :manage, Allocation, job: { provider: { id: user.id }}

    elsif user.is_a?(Seeker)
      can :read, Job, provider: { place: { id: user.place.id }}

      can :manage, Allocation, seeker: { id: user.id }
    end
  end
end
