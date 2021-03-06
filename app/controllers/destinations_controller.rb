class DestinationsController < ApplicationController

  load_and_authorize_resource :trip
  load_and_authorize_resource through: :trip

  respond_to :json, only: %w(update minor_update create_comment)

  def edit
  end

  def show
  end

  def update
    @destination.transaction do
      @expenses = expenses_params.map do |expense_params|
        expense = @destination.expenses.find_by_id(expense_params[:id]) || Expense.new
        expense.name = expense_params[:name].blank? ? 'Unknown' : expense_params[:name]
        expense.destination = @destination
        expense.category = expense_params[:category].blank? ? 'other' : expense_params[:category]
        if expense_params[:comments] && expense_params[:comments].any?
          expense_params[:comments].each do |comment|
            expense.comments.new(comment.slice(:body).merge(traveller: current_user))
          end
        end

        alternatives = expense_params[:alternatives].map do |alternative_params|
          unless alternative_params[:cost].blank?
            alternative = expense.alternatives.find_by_id(alternative_params[:id]) || Alternative.new
            alternative.assign_attributes(alternative_params.merge(expense: expense))
            alternative.cost = 0 if alternative.cost.blank?
            alternative
          end
        end.compact

        { expense: expense, alternatives: alternatives }
      end
      @expenses.each do |e|
        e[:expense].transaction do
          e[:expense].save!
          e[:alternatives].each(&:save!)
        end
      end
      @destination.expenses = @expenses.map {|eh| eh[:expense] }
      @destination.save
    end
    render json: @expenses
  end

  def minor_update
    if params[:value]
      @destination.update_attribute(:name, params[:value])
    elsif params[:destination_travellers_ids].kind_of?(Array)
      @destination.travellers = @trip.travellers.where(id: params[:destination_travellers_ids]).all
    end
    render json: @destination
  end

  def create_comment
    @comment = Comment.new
    if params[:comment] && !params[:comment][:body].blank? && !params[:comment][:expense_id].blank?
      expense = @destination.expenses.find_by_id(params[:comment][:expense_id])
      @comment = expense.comments.create({ body: params[:comment][:body] }.merge(traveller: current_user))
    end
    render json: @comment
  end

  private
  def destination_params
    params[:destination].slice(:name, :google_address, :from_date, :to_date)
  end

  def expenses_params
    return @expenses_params if @expenses_params
    @expenses_params = (params[:expenses] || {}).values.map do |expense|
      alternative_params = (expense[:alternatives] || {}).values.map do |alternative|
        alternative.slice(:id, :cost, :person_gap, :time_gap, :link, :is_checked, :provider)
      end
      e_params = expense.slice(:id, :name, :category).merge(alternatives: alternative_params)
      e_params[:comments] = []
      expense[:comments].values.each do |comment|
        e_params[:comments] << { body: comment[:body] } unless comment[:body].blank?
      end if expense[:comments]
      e_params
    end
  end
end
