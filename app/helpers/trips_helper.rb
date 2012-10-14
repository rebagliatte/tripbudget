module TripsHelper

  def travellers_to_sentence(trip)
    array = []

    trip.travellers.each do |traveller|
      array << link_to(traveller.display_name, traveller_path(traveller))
    end

    array.to_sentence.html_safe
  end

  def travellers_to_images(trip)
    string = ''

    trip.travellers.each do |traveller|
      string << link_to(traveller_path(traveller)) { image_tag("#{traveller.image.blank? ? '/assets/default_traveller.png' : traveller.image}") }
    end

    string.html_safe
  end
end
