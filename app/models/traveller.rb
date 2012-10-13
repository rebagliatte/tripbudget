class Traveller < ActiveRecord::Base

  has_many :comments
  has_and_belongs_to_many :trips
  has_and_belongs_to_many :expenses

  validates :name, presence: true
  validates :uid, presence: true

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.nickname = auth["info"]["nickname"]
      user.name = auth["info"]["name"]
      user.location = auth["info"]["location"]
      user.image = auth["info"]["image"]
      user.description = auth["info"]["description"]
      user.url = auth["info"]["urls"]["Website"]
      user.twitter_url = auth["info"]["urls"]["Twitter"]
    end
  end

end
