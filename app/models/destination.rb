class Destination < ActiveRecord::Base

  has_many :expenses
  belongs_to :trip

  validates :name, presence: true
  validates :from_date, presence: true
  validates :to_date, presence: true

  def total_days
    (to_date - from_date).to_i + 1
  end

  def total_travellers
    1 # TODO
  end

end
