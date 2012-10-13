class TripsController < ApplicationController

  load_and_authorize_resource

  skip_load_resource only: :create

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
                  UserMailer.notice_trip_invitation_email(user, trip).deliver!
                  user
                else
                  user = Traveller.create!(email: email, invitation_url: Trip.get_random_invitation_code)
                  UserMailer.invite_email(user, trip).deliver!
                  user
                end
      trip.travellers << invitee
    end

    any_destination = destinations.any?
    destinations_valid = destinations.all?(&:valid?)
    trip_valid = @trip.valid?

    if any_destination && destinations_valid && trip_valid
      @trip.save!

      # Notify Invitees
      invitees = trip_params[:invitees].split(',').map(&:strip)
      invitees.each do |email|
        invitee = if user = Traveller.find_by_email(email)
          UserMailer.notice_trip_invitation_email(user, trip).deliver!
          user
        else
          user = Traveller.create!(email: email, invitation_url: Trip.get_random_invitation_code)
          UserMailer.invite_email(user).deliver!
          user
        end
        trip.travellers << invitee
      end

      # Success!
      redirect_to edit_destination_path(destinations.first), flash: { success: 'Trip created successfully. Now edit your destination!' }
    else
      errors = []
      errors << 'Invalid destinations' unless destinations_valid
      errors << 'You must pick at least one destination' unless any_destination
      flash.now[:error] = errors if errors.any?

      render @trip.new_record? :new : :edit
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def trip_params
    return @trip_params if @trip_params
    @trip_params = params[:trip].slice(:name, :description, :is_public, :invitees)
    @trip_params[:destinations] = (params[:trip][:destinations] || {}).values.reject {|d| d[:name].blank? }.map do |destination_params|
      destination_params.slice(:name, :from_date, :to_date)
    end
    @trip_params
  end
end
