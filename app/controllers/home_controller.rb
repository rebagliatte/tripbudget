class HomeController < ApplicationController
  def index
    @editor_picks = Trip.handpicked.limit(3).all
    @popular_picks = Trip.popular(3).all
    @latest_picks = Trip.latest.limit(3).all
  end
end
