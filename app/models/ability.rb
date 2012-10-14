class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :create, Trip
      can :read, Trip, is_public: true
      can [:read, :update], Trip do |trip|
        trip.travellers.include?(user)
      end
      can :destroy, Trip, owner_id: user.id
      can :read, Traveller do |traveller|
        (user.trips & traveller.trips).any?
      end
      can :update, Traveller, id: user.id
      can :update, Destination do |destination|
        user.trips.include?(destination.trip)
      end
      can :minor_update, Destination do |destination|
        user.trips.include?(destination.trip)
      end
    end

    # Everybody can access these
    can :read, Traveller do |traveller|
      traveller.trips.where(is_public: true).any?
    end
  end
end
