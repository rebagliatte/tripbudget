class HomeController < ApplicationController
  def index
    @editor_picks = Trip.where(is_public: true).where(is_featured: true).limit(3).all
    popular_picks_ids = Trip
      .select('trips.id, COUNT(*) as travellers_count')
      .joins(:travellers)
      .where(is_public: true)
      .group('trips.id')
      .order('travellers_count DESC').limit(3).map(&:id)
    @popular_picks = Trip.where(id: popular_picks_ids).all

    @latest_picks = Trip.where(is_public: true).limit(3).all
  end
end
