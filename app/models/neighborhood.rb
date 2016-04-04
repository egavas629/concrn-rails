module Neighborhood
	def self.at(lat, long)
	  lat = lat.to_f
	  long = long.to_f

	  url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{lat},#{long}&key=#{ENV['GoogleAPI']}"
	  
	  response = HTTParty.get(url)

	  response["results"][0]["address_components"][2]["short_name"]
	end
end