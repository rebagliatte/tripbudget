class TripsController < ApplicationController

  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    # TODO

    redirect to new_destination_path
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
