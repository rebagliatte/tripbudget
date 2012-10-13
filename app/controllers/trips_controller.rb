class TripsController < ApplicationController

  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    # TODO
    trip = Trip.create!(name: params[:trip][:name], owner_id: params[:trip][:owner_id])

    invitees = params[:trip][:invitees].split(",").map{|i| i.strip }
    invitees.each do |email|
      invitee = if user = Traveller.find_by_email(email)
                  user
                else
                  user = Traveller.create!(email: email, invitation_url: Trip.get_random_invitation_code)
                  UserMailer.invite_email(user).deliver
                  user
                end
      trip.travellers << invitee
    end

    redirect to new_trip_destination_path
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
