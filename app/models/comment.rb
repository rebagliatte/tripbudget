class Comment < ActiveRecord::Base

  belongs_to :expense
  belongs_to :traveller

  validates :body, presence: true

end
