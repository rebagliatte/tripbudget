class TripsController < ApplicationController

  load_and_authorize_resource

  skip_load_resource only: :create

  def index
  end

  def new
  end

  def create
    @trip = Trip.new(trip_params.slice(:name, :description, :is_public).merge(owner: Traveller.first || current_user))

    destinations = trip_params[:destinations].map do |destination_params|
      @trip.destinations.new(destination_params)
    end

    any_destination = destinations.any?
    destinations_valid = destinations.all?(&:valid?)
    trip_valid = @trip.valid?

    if any_destination && destinations_valid && trip_valid
      @trip.save!
      redirect_to edit_destination_path(destinations.first), flash: { success: 'Trip created successfully. Now edit your destination!' }
    else
      errors = []
      errors << 'Invalid destinations' unless destinations_valid
      errors << 'You must pick at least one destination' unless any_destination
      flash.now[:error] = errors if errors.any?

      render :new
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
    @trip_params = params[:trip].slice(:name, :description, :is_public)
    @trip_params[:destinations] = (params[:trip][:destinations] || {}).values.reject {|d| d[:name].blank? }.map do |destination_params|
      destination_params.slice(:name, :from_date, :to_date)
    end
    @trip_params
  end
end
