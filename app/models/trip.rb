class Trip < ActiveRecord::Base
  attr_accessor :invitees

  has_many :destinations
  has_and_belongs_to_many :travellers
  belongs_to :owner, class_name: 'Traveller'

  validates :name, presence: true
  # validates :is_public, presence: true

  def self.get_random_invitation_code
    rand(36**8).to_s(36)
  end
end
