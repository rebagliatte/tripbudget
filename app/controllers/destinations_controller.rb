class DestinationsController < ApplicationController

  load_and_authorize_resource

  def index
  end

  def edit
  end

  def update
    @expenses = expenses_params.map do |expense_params|
      expense = @destination.expenses.find_by_id(expense_params[:id]) || @destination.expenses.new
      expense.name = expense_params[:name].blank? ? 'Unknown' : expense_params[:name]

      expense.alternatives = expense_params[:alternatives].map do |alternative_params|
        alternative = expense.alternatives.find_by_id(alternative_params[:id]) || expense.alternatives.new
        alternative.assign_attributes(alternative_params)
        alternative
      end
      expense
    end
    @destination.transaction do
      @expenses.each(&:save!)
    end
    render json: @expenses
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
