class ExpensesController < ApplicationController

  load_and_authorize_resource :trip
  load_and_authorize_resource :destination, trough: :trip
  load_and_authorize_resource trough: :destination

  def new

  end

  def create_all
  end
end
