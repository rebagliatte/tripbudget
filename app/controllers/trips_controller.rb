class TripsController < ApplicationController

  before_filter :load_trip_on_create, only: :create
  before_filter :load_trip_on_update, only: :update
  load_and_authorize_resource

  EMAIL_REGEXP = /\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/

  def show
  end

  def index
    @trips = current_user ? current_user.trips.active : Trip.public.all
  end

  def popular
    @trips = Trip.popular(10).all
    render :index
  end

  def handpicked
    @trips = Trip.handpicked.all
    render :index
  end

  def latest
    @trips = Trip.latest.all
    render :index
  end

  def new
  end

  def create
    create_or_update_trip
  end

  def edit
  end

  def update
    create_or_update_trip
  end

  def summary
  end

  def create_or_update_trip
    destinations = trip_params[:destinations].map do |destination_params|
      if destination = @trip.destinations.find_by_id(destination_params[:id])
        destination.assign_attributes(destination_params)
        destination
      else
        Destination.new(destination_params.merge(trip: @trip))
      end
    end

    any_destination = destinations.any?
    destinations_valid = destinations.all?(&:valid?)
    trip_valid = @trip.valid?

    if any_destination && destinations_valid && trip_valid
      @trip.transaction do
        destinations.map(&:save!)
        @trip.destinations = destinations
        @trip.save!
        notify_new_invitees

        destinations.each do |d|
          d.travellers = @trip.travellers
        end
      end

      # Success!
      redirect_to edit_trip_destination_path(@trip, destinations.first), flash: { success: 'Trip saved successfully. Now edit your destinations!' }
    else
      errors = []
      errors << 'Invalid destinations' unless destinations_valid
      errors << 'You must pick at least one destination' unless any_destination
      flash.now[:error] = errors if errors.any?

      render @trip.new_record? ? :new : :edit
    end
  end

  def destroy
    @trip.update_attribute(:is_active, false)
    redirect_to trips_path, flash: { success: 'Trip destroyed successfully!' }
  end

  private
  def trip_params
    return @trip_params if @trip_params
    @trip_params = params[:trip].slice(:name, :description, :is_public, :invitees)
    @trip_params[:destinations] = (params[:trip][:destinations] || {}).values.reject {|d| d[:name].blank? }.map do |destination_params|
      {
        id: destination_params[:id],
        name: destination_params[:name],
        from_date: Date.strptime(destination_params[:from_date], '%m/%d/%Y'),
        to_date: Date.strptime(destination_params[:to_date], '%m/%d/%Y')
      }
    end
    @trip_params
  end

  def notify_new_invitees
    old_invitees = @trip.travellers.all.map(&:email)
    new_invitees = trip_params[:invitees].scan(EMAIL_REGEXP).uniq

    (new_invitees - old_invitees).each do |email|
      invitee = if user = Traveller.find_by_email(email)
        UserMailer.notice_trip_invitation_email({
          inviter: @trip.owner, # TODO
          invitee: user,
          trip: @trip
        }).deliver
        user
      else
        user = Traveller.create!(email: email, invitation_url: Trip.get_random_invitation_code)
        UserMailer.invite_email({
          inviter: @trip.owner, # TODO
          invitee: user,
          trip: @trip
        }).deliver
        user
      end
      @trip.travellers << invitee
    end
    @trip.travellers << current_user unless @trip.travellers.include?(current_user)
  end

  def load_trip_on_create
    @trip = Trip.new(trip_params.slice(:name, :description, :is_public).merge(owner: current_user, is_active: true))
  end

  def load_trip_on_update
    @trip = Trip.find(params[:id])
    @trip.assign_attributes(trip_params.slice(:name, :description, :is_public))
  end
end
