class Destination < ActiveRecord::Base

  has_many :expenses
  belongs_to :trip

  validates :name, presence: true
  validates :from_date, presence: true
  validates :to_date, presence: true

end
