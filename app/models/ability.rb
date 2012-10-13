class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, [Trip, Destination, Expense, Alternative, Traveller, Comment]
  end
end
