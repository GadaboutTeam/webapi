require 'sinatra/activerecord'

class User < ActiveRecord::Base
	has_many :friendships
	has_many :friends, -> { where(friendships: {accepted: true})}, :through => :friendships

	validates :username, :auth_id, :auth_token, presence: true
	validates :auth_id, uniqueness: true

	self.rgeo_factory_generator =  RGeo::Geographic.spherical_factory(srid: 4326, geographic: true)
	set_rgeo_factory_for_column :loc, RGeo::Geographic.spherical_factory(srid: 4326)


	# distance away is in meters
	def get_friends(distance_away = nil)
		friends = self.friends.where(["ST_DWithin(users.loc, ST_GeomFromText(?), ?)", self.loc.to_s, distance_away])
		return friends
	end

end
