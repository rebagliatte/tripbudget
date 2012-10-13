class InvitationsController < ApplicationController
  def show
    # supongo que el invitado ya esta logueado, como resuelvo eso?
    invitee = Traveller.find_by_invitation_url(params[:id])
    render_404 and return unless invitee

    if current_user
      current_user.email = invitee.email
      current_user.trips << invitee.trips
      current_user.save

      invitee.destroy
      redirect_to trip_destination_path(current_user.trips.last), flash: { success: "Invitation received successfully." }
    else
      session[:invitation_token] = params[:id]
      redirect_to root_url, flash: { notice: "Please sign in or sign up to access the trips content" }
    end

  end
end
