class TripsController < ApplicationController

  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      redirect_to new_destination_path(@trip), flash: { success: 'Trip created successfully. Now add your destination!' }
    else
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
    params[:trip].slice(:name, :description, :is_public)
  end
end
