require 'sinatra/activerecord'
class User < ActiveRecord::Base
	has_many :friendships
	has_many :friends, :through => :friendships

	self.rgeo_factory_generator =  RGeo::Geographic.spherical_factory(srid: 4326, geographic: true)
	set_rgeo_factory_for_column :loc, RGeo::Geographic.spherical_factory(srid: 4326)

	# distance away is in meters
	def get_friends(distance_away = nil)
		friends = self.friends.where(accepted: true)
		friends = friends.where(["ST_Distance(loc, ?) < ?",self.loc, distance_away])
		return friends
	end
end
