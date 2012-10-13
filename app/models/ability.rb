class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :read, Trip, is_public: true
      can :manage, Trip do |trip|
        trip.travellers.includes?(user)
      end
      can :read, Traveller do |traveller|
        (user.trips & traveller.trips).any?
      end
      can :edit, Traveller, id: user.id
      can :edit, Destination do |destination|
        user.trips.includes?(destination.trip)
      end
    end

    # Everybody can access these
    can :read, Traveller do |traveller|
      traveller.trips.where(is_public: true).any?
    end
  end
end
