class Expense < ActiveRecord::Base

  has_many :alternatives
  belongs_to :destination
  has_many :comments
  has_and_belongs_to_many :travellers

  PERSON_GAPS = %w(per_person per_group)
  TIME_GAPS = %w(per_day per_stay)

  validates :name, presence: true
  validates :person_gap, inclusion: { in: PERSON_GAPS }
  validates :time_gap, inclusion: { in: TIME_GAPS }

end
