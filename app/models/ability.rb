class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :create, Trip
      can [:read, :summary, :update], Trip do |trip|
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
      can [:minor_update, :create_comment], Destination do |destination|
        user.trips.include?(destination.trip)
      end
    end

    can [:read, :summary], Trip, is_public: true
    # Everybody can access these
    can :read, Traveller do |traveller|
      traveller.trips.where(is_public: true).any?
    end
    can [:popular, :latest, :handpicked], Trip
  end
end
