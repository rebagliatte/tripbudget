class Trip < ActiveRecord::Base

  has_many :destinations
  has_and_belongs_to_many :travellers
  belongs_to :owner, class_name: 'Traveller'

  validates :name, presence: true
  validates :is_public, presence: true

end
