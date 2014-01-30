class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Admin)
      can :access, :rails_admin
      can :manage, :all

    elsif user.is_a?(Broker)
      places = user.places.pluck(:id)

      can :manage, Provider, place: { id: places }
      can :manage, Seeker, place: { id: places }
      can :manage, Job, provider: { place: { id: places } }

    elsif user.is_a?(Provider)
      can :manage, Job, provider: user
    end
  end
end
