class Trip < ActiveRecord::Base
  attr_accessor :invitees

  has_many :destinations
  has_and_belongs_to_many :travellers
  belongs_to :owner, class_name: 'Traveller'

  validates :name, presence: true

  default_scope order('trips.id DESC')
  scope :active, where(is_active: true)

  def invitees
    travellers.reject {|t| t == owner }.map(&:email).join(", ")
  end

  def self.get_random_invitation_code
    rand(36 ** 8).to_s(36)
  end

  def duration_in_days
    destinations.inject(0) {|total, destination| total += destination.total_days }
  end

  def total_per_group
    destinations.inject(0) {|total, destination| total += destination.total_per_group }
  end

  def total_per_person
    total_per_group/travellers.count
  end

  def totals_per_category
    accomodation = total_per_category('accomodation')
    transportation = total_per_category('transport')
    meals = total_per_category('meals')
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

  def self.handpicked
    active.where(is_public: true).where(is_featured: true)
  end

  def self.popular(n)
    popular_picks_ids = select('trips.id, COUNT(*) as travellers_count')
                            .joins(:travellers)
                            .where(is_public: true).active
                            .group('trips.id')
                            .order('travellers_count DESC').limit(n).map(&:id)
    where(id: popular_picks_ids)
  end

  def self.latest
    where(is_public: true).active
  end

private

  def total_per_category(category)
    destinations.inject(0) {|total, destination| total += destination.total_per_group_and_category(category) }
  end
end
