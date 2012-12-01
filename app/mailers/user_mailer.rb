class UserMailer < ActionMailer::Base

  default from: 'tripbudget2012@gmail.com'

  def invite_email(options = {})
    load_mail_resources(options)
    mail(to: @invitee.email, subject: 'You were invited to TripBudget!')
  end

  def notice_trip_invitation_email(options = {})
    load_mail_resources(options)
    mail(to: @invitee.email, subject: 'You were invited to a new trip!')
  end

  private
  def load_mail_resources(options = {})
    @invitee = options.fetch(:invitee)
    @trip = options.fetch(:trip)
    @inviter = options.fetch(:inviter)
  end
end
