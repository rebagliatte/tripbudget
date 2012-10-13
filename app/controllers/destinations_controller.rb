class DestinationsController < ApplicationController

  load_and_authorize_resource

  def index
  end

  def new
    @destination = Destionation.new(destination_params)
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def destination_params
    params[:destination].slice(:name, :google_address, :from_date, :to_date)
  end
end
