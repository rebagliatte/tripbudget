class InvitationsController < ApplicationController
  def show
    # supongo que el invitado ya esta logueado, como resuelvo eso?
    invitee = Traveller.find_by_invitation_url(params[:id])
    render_404 and return unless invitee

    current_user.email = invitee.email
    current_user.trips << invitee.trips
    current_user.save

    invitee.destroy

    redirect_to trip_destination_path
  end
end
