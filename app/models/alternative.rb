class Alternative < ActiveRecord::Base

  belongs_to :expense

  PERSON_GAPS = %w(per_person per_group)
  TIME_GAPS = %w(per_day per_stay)

  validates :cost, presence: true
  validates :person_gap, inclusion: { in: PERSON_GAPS }
  validates :time_gap, inclusion: { in: TIME_GAPS }

end
