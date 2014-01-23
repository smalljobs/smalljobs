class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Admin)
      can :access, :rails_admin
      can :manage, :all

    elsif user.is_a?(Broker)
      broker_zips = user.places.pluck(:zip)

      can :manage, Provider, Provider.where(zip: broker_zips) do |p|
        p.zip.blank? || broker_zips.include?(p.zip)
      end

      can :manage, Seeker, Seeker.where(zip: broker_zips) do |s|
        s.zip.blank? || broker_zips.include?(s.zip)
      end

      can :manage, Job, Job.where(provider_id: { zip: broker_zips }) do |j|
        broker_zips.include?(j.provider.zip)
      end
    end
  end
end
