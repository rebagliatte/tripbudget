class Alternative < ActiveRecord::Base

  belongs_to :expense

  validates :cost, presence: true
  validates :person_gap, presence: true
  validates :time_gap, presence: true

end
