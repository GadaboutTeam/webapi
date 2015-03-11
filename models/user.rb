require 'rest_client'
require 'openssl'
require 'sinatra/activerecord'
class User < ActiveRecord::Base
	has_many :friendships
	has_many :friends, :through => :friendships

	validates :first_name, :last_name, :email, :fb_id, :auth_token, presence: true
	validates :email, :fb_id, uniqueness: true

	self.rgeo_factory_generator =  RGeo::Geographic.spherical_factory(srid: 4326, geographic: true)
	set_rgeo_factory_for_column :loc, RGeo::Geographic.spherical_factory(srid: 4326)

before_validation do

puts self.auth_token
puts ENV['FB_TOKEN']
response = RestClient.get URI.encode("https://graph.facebook.com/debug_token?input_token=#{self.auth_token}&access_token=#{ENV['FB_TOKEN']}")
puts "**********\n #{response.inspect}\n**********"

end

	# distance away is in meters
	def get_friends(distance_away = nil)
		friends = self.friends.where(accepted: true)
		friends = friends.where(["ST_Distance(loc, ?) < ?", self.loc, distance_away])
		return friends
	end
end
