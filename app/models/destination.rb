class Destination < ActiveRecord::Base

  has_many :expenses
  belongs_to :trip
  has_and_belongs_to_many :travellers

  validates :name, presence: true
  validates :from_date, presence: true
  validates :to_date, presence: true

  default_scope order('destinations.id ASC')

  def total_days
    (to_date - from_date).to_i + 1
  end

  def next_destination
    @next_destination ||= trip.destinations.where('destinations.id > ?', id).first
  end

  def prev_destination
    @prev_destination ||= trip.destinations.where('destinations.id < ?', id).last
  end

  def total_per_group
    total = 0
    expenses.each do |expense|
      alternative = expense.active_alternative
      if alternative
        if alternative.person_gap == 'per_person'
          alternative_cost = alternative.cost * trip.travellers.count
        else
          alternative_cost = alternative.cost
        end

        alternative_cost = alternative.cost * total_days if alternative.time_gap == 'per_day'

        total += alternative_cost
      end
    end
    total
  end

  def total_per_group_and_category(category)
    total = 0
    expenses.each do |expense|
      alternative = expense.active_alternative
      if alternative
        if expense.category == category
          if alternative.person_gap == 'per_person'
            alternative_cost = alternative.cost * trip.travellers.count
          else
            alternative_cost = alternative.cost
          end

          alternative_cost = alternative.cost * total_days if alternative.time_gap == 'per_day'

          total += alternative_cost
        end
      end
    end
    total
  end
  def total_per_person
    total_per_group/trip.travellers.count
  end
end
