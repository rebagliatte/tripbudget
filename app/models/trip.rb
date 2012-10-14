class Trip < ActiveRecord::Base
  attr_accessor :invitees

  has_many :destinations
  has_and_belongs_to_many :travellers
  belongs_to :owner, class_name: 'Traveller'

  validates :name, presence: true

  default_scope order('trips.id ASC')

  def invitees
    travellers.reject {|t| t == owner }.map(&:email).join(", ")
  end

  def self.get_random_invitation_code
    rand(36 ** 8).to_s(36)
  end

  def total_per_group
    destinations.inject(0) {|total, destination| total += destination.total_per_group }
  end

  def total_per_person
    total_per_group/travellers.count
  end

  def totals_per_category
    accomodation = total_per_category('Accomodation')
    transportation = total_per_category('Transport')
    meals = total_per_category('Meals')
    other = total_per_group - accomodation - transportation - meals

    [['Accomodation',  accomodation ],
    ['Transport', transportation ],
    ['Meals', meals ],
    ['Other', other]]
  end

  def totals_per_destination
    destinations.map do |destination|
      [destination.name, destination.total_per_group]
    end
  end

private

  def total_per_category(category)
    destinations.inject(0) {|total, destination| total += destination.total_per_group_and_category(category) }
  end
end
