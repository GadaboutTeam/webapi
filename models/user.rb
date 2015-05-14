require 'sinatra/activerecord'
require 'oauth'
require 'rest_client'
require 'openssl'

class User < ActiveRecord::Base
# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
	has_many :friendships
	has_many :friends, -> { where(friendships: {accepted: true})}, :through => :friendships
	has_many :invitations, primary_key: "auth_id", foreign_key: "user_id"
	has_many :events,  -> { where.not(invitations: {reply: 2})}, through: :invitations


	validates :username, :auth_id, :auth_token, :device_id, presence: true
	validates :auth_id, uniqueness: true

	self.rgeo_factory_generator =  RGeo::Geographic.spherical_factory(srid: 4326, geographic: true)
	set_rgeo_factory_for_column :loc, RGeo::Geographic.spherical_factory(srid: 4326)


	# distance away is in meters
	def get_friends(distance_away = 20037508)
		friends = self.friends.where(["ST_DWithin(users.loc, ST_GeomFromText(?), ?)", self.loc.to_s, distance_away]).select("username, phone_number, auth_id, loc")
		return friends
	end

	def self.verify_credentials(access_token, auth_id)
		resource = RestClient::Resource.new "https://graph.facebook.com/me?access_token=#{access_token}" 
		response = JSON.parse resource.get
		return response["id"] == auth_id
	end




	# def self.verify_credentials(auth_token, auth_token_secret, auth_id)
	# 	consumer = OAuth::Consumer.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"], { :site => "https://api.twitter.com", :scheme => :header })
	# 	token_hash = { :oauth_token => auth_token, :oauth_token_secret => auth_token_secret }
	# 	access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
	# 	puts access_token.inspect
	# 	puts
	# 	response = access_token.get('https://api.twitter.com/1.1/account/verify_credentials.json', 'Accept' => 'application/xml') 
	# 	puts response.inspect
	# 	# return true 
	# end
end




		# response = access_token.request(:get, 'https://api.twitter.com/1.1/account/verify_credentials.json')
