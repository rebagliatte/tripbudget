class Alternative < ActiveRecord::Base

  belongs_to :expense

  PERSON_GAPS = %w(per_person per_group)
  TIME_GAPS = %w(per_day per_stay)

  validates :person_gap, inclusion: { in: PERSON_GAPS }
  validates :time_gap, inclusion: { in: TIME_GAPS }

  def per_group?
    person_gap == 'per_group'
  end

  def per_person?
    person_gap == 'per_person'
  end

  def per_day?
    time_gap == 'per_day'
  end

  def per_stay?
    time_gap == 'per_stay'
  end
end
