class TripsController < ApplicationController

  load_and_authorize_resource

  skip_load_resource only: %w(create update)

  def index
  end

  def new
  end

  def create
    @trip = Trip.new(trip_params.slice(:name, :description, :is_public).merge(owner: current_user))
    create_or_update_trip
  end

  def edit
  end

  def update
    @trip = Trip.find(params[:id])
    @trip.assign_attributes(trip_params.slice(:name, :description, :is_public))
    create_or_update_trip
  end

  def create_or_update_trip
    @trip.destinations.clear

    destinations = trip_params[:destinations].map do |destination_params|
      @trip.destinations.new(destination_params)
    end

    any_destination = destinations.any?
    destinations_valid = destinations.all?(&:valid?)
    trip_valid = @trip.valid?

    if any_destination && destinations_valid && trip_valid
      @trip.save!
      notify_new_invitees

      # Success!
      redirect_to edit_trip_destination_path(@trip, destinations.first), flash: { success: 'Trip created successfully. Now edit your destination!' }
    else
      errors = []
      errors << 'Invalid destinations' unless destinations_valid
      errors << 'You must pick at least one destination' unless any_destination
      flash.now[:error] = errors if errors.any?

      render @trip.new_record? ? :new : :edit
    end
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

  def notify_new_invitees
    old_invitees = @trip.travellers.all.map(&:email)
    new_invitees = trip_params[:invitees].split(',').map(&:strip)

    (new_invitees - old_invitees).each do |email|
      invitee = if user = Traveller.find_by_email(email)
        UserMailer.notice_trip_invitation_email(user, trip).deliver!
        user
      else
        user = Traveller.create!(email: email, invitation_url: Trip.get_random_invitation_code)
        UserMailer.invite_email(user).deliver!
        user
      end
      @trip.travellers << invitee
    end
  end
end
