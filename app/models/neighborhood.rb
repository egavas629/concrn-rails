require 'google_places'

module Neighborhood
  @client ||= GooglePlaces::Client.new(ENV['GoogleAPI'])
  
  def self.at(lat, long, client=@client)
    spots = client.spots(lat, long)
    spots.any? ? spots.first.vicinity : nil
  end
end