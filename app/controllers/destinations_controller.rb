class DestinationsController < ApplicationController

  load_and_authorize_resource :trip
  load_and_authorize_resource through: :trip

  respond_to :json, only: %w(update minor_update)

  def index
  end

  def edit
  end

  def update
    @destination.transaction do
      @expenses = expenses_params.map do |expense_params|
        expense = @destination.expenses.find_by_id(expense_params[:id]) || Expense.new
        expense.name = expense_params[:name].blank? ? 'Unknown' : expense_params[:name]
        expense.destination = @destination

        expense.alternatives = expense_params[:alternatives].map do |alternative_params|
          alternative = expense.alternatives.find_by_id(alternative_params[:id]) || expense.alternatives.new
          alternative.assign_attributes(alternative_params)
          alternative.cost = 0 if alternative.cost.blank?
          alternative
        end
        expense
      end
      @expenses.each(&:save!)
      @destination.expenses = @expenses
    end
    render json: @expenses
  end

  def minor_update
    if params[:value]
      @destination.update_attribute(:name, params[:value])
    else
      @destination.travellers = @trip.travellers.where(id: params[:destination_travellers_ids]).all
    end
    render json: @destination
  end

  def destroy
  end

  private
  def destination_params
    params[:destination].slice(:name, :google_address, :from_date, :to_date)
  end

  def expenses_params
    return @expenses_params if @expenses_params
    @expenses_params = (params[:expenses] || {}).values.map do |expense|
      alternative_params = (expense[:alternatives] || {}).values.map do |alternative|
        alternative.slice(:id, :cost, :person_gap, :time_gap, :link, :is_checked)
      end
      expense.slice(:id, :name).merge(alternatives: alternative_params)
    end
  end
end
