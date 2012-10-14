class SessionsController < ApplicationController
  def create
    email = env["omniauth.auth"]['info']['email']
    uid = env["omniauth.auth"]['uid']
    user_with_email = Traveller.find_by_email(email)
    user_with_uid = Traveller.where(provider: :facebook, uid: uid).first

    if !session[:user_id].blank?
      redirect_to root_url, flash: { error: 'You\'re already signed in' }
    elsif user_with_email && !user_with_uid
      redirect_to root_url, flash: { error: 'This email is already in used by another account' }
    else
      user = Traveller.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id

      if session[:invitation_token] && invitee = Traveller.find_by_invitation_url(session[:invitation_token])
        current_user.email = invitee.email
        current_user.trips << invitee.trips
        current_user.save

        invitee.destroy

        redirect_to trip_destinations_path(current_user.trips.last), flash: { success: "Invitation received successfully." }
      else
        redirect_to root_url, notice: "Signed in!"
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
