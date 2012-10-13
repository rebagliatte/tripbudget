class UserMailer < ActionMailer::Base
  default from: "tripbudget2012@gmail.com"

  def invite_email(traveller)
    @traveller = traveller
    mail(:to => traveller.email, :subject => 'You were invited to TripBudget!')
  end
end
