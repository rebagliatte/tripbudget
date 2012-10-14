class Expense < ActiveRecord::Base

  has_many :alternatives
  belongs_to :destination
  has_many :comments

  validates :name, presence: true

end
