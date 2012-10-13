class UserMailer < ActionMailer::Base
  default from: "tripbudget2012@gmail.com"

  def invite_email(traveller)
    @traveller = traveller
    mail(:to => traveller.email, :subject => 'You were invited to TripBudget!')
  end

  def notice_trip_invitation_email(traveller, trip)
    @traveller = traveller
    @trip = trip
    mail(:to => traveller.email, :subject => 'You were invited to a new trip!')
  end
end
