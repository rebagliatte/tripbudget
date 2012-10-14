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
end
