class SessionsController < ApplicationController
  def create
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

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
