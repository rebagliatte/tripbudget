class Trip < ActiveRecord::Base
  attr_accessor :invitees

  has_many :destinations
  has_and_belongs_to_many :travellers
  belongs_to :owner, class_name: 'Traveller'

  validates :name, presence: true

  default_scope order('trips.id ASC')

  def self.get_random_invitation_code
    rand(36 ** 8).to_s(36)
  end

  def total_per_group
    destinations.inject(0) {|total, destination| total += destination.total_per_group }
  end

  def total_per_person
    total_per_group/travellers.count
  end
end
