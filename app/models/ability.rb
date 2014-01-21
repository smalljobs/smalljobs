class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Admin)
      can :access, :rails_admin
      can :manage, :all

    elsif user.is_a?(Broker)

      regions = user.places.pluck(:zip)

      can :read, Provider
      can :update, Provider

      can :create, Provider, zip: regions
      can :destroy, Provider, zip: regions
    end
  end
end
