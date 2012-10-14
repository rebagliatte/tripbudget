class Expense < ActiveRecord::Base

  has_many :alternatives
  belongs_to :destination
  has_many :comments

  validates :name, presence: true

  def active_alternative
    alternatives.where(is_checked: true).first
  end
end
