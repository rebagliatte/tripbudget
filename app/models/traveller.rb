class Traveller < ActiveRecord::Base

  has_many :comments
  has_and_belongs_to_many :trips
  has_and_belongs_to_many :expenses

  validates :name, presence: true
  validates :twitter_uid, presence: true

end
