class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Admin)
      can :access, :rails_admin
      can :manage, :all

    elsif user.is_a?(Broker)
      places = user.places.pluck(:id)

      can :manage, Organization, place: { id: places }

      can :manage, Provider, place: { id: places }
      can :manage, Seeker, place: { id: places }

      can :manage, Job, provider: { place: { id: places }}
      can :activate, Job, provider: { place: { id: places }}

      can :manage, Proposal, job: { provider: { place: { id: places }}}
      can :manage, Application, job: { provider: { place: { id: places }}}
      can :manage, Allocation, job: { provider: { place: { id: places }}}
      can :manage, Review, job: { provider: { place: { id: places }}}

    elsif user.is_a?(Provider)
      can :manage, Job, provider: { id: user.id }

      can :read, Allocation, job: { provider: { id: user.id }}
      can :manage, Review, job: { provider: { id: user.id }}

    elsif user.is_a?(Seeker)
      can :read, Job, provider: { place: { id: user.place.id }}

      can :read, Proposal, seeker: { id: user.id }
      can :manage, Application, seeker: { id: user.id }
      can :read, Allocation, seeker: { id: user.id }
      can :manage, Review, provider: { place: { id: user.place.id }}
    end
  end
end
