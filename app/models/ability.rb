class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Admin)
      can :access, :rails_admin
      can :manage, :all

    elsif user.is_a?(Broker)
      clear_aliased_actions
      can [:new, :update], Provider
      can :manage, Provider, zip: user.places.pluck(:zip)
    end
  end
end
