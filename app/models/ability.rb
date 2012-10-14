class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :create, Trip
      can [:read, :summary, :update], Trip do |trip|
        trip.is_active? && trip.travellers.include?(user)
      end
      can :destroy, Trip do |trip|
        trip.is_active? && trip.owner_id == user.id
      end
      can :read, Traveller do |traveller|
        (user.trips & traveller.trips).any?
      end
      can :update, Traveller, id: user.id
      can :update, Destination do |destination|
        destination.trip.is_active? && user.trips.include?(destination.trip)
      end
      can [:minor_update, :create_comment], Destination do |destination|
        destination.trip.is_active? && user.trips.include?(destination.trip)
      end
    end

    can [:read, :summary], Trip do |trip|
      trip.is_public? && trip.is_active?
    end
    # Everybody can access these
    can :read, Traveller do |traveller|
      traveller.trips.where(is_public: true).active.any?
    end
    can [:popular, :latest, :handpicked], Trip
  end
end
