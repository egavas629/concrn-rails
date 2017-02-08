require 'google_places'

module Neighborhood
  @client ||= GooglePlaces::Client.new(ENV['GoogleAPI'])
  
  def self.at(lat, long, client=@client)
    return unless lat && long

    client.spots(lat, long).try(:first).try(:vicinity)

  rescue Exception => e
    Rails.logger.warn("error querying for neighborhood for (#{lat} #{long}): #{e}")
    nil
  end

end