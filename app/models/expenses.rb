class Expenses < ActiveRecord::Base

  has_many :alternatives
  belongs_to :destination
  has_many :comments
  has_and_belongs_to_many :travellers

  validates :name, presence: true

end
