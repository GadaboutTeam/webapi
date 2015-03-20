require 'sinatra/base'
require 'sinatra/activerecord'
require_relative '../models/user'
require_relative '../models/friendship'

class FriendRoutes < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	post '/' do
		user = User.find_by(auth_id: params[:auth_id])
		friend = User.find_by(auth_id: params[:friend_id])
		
		Friendship.connect(user.id, friend.id) if user && friend

		{"message": "Friendship sent."}.to_json
	end

	delete '/' do
		user = User.find_by(auth_id: params[:auth_id])
		Friendship.delete(user.id, params[:friend_id])
		{"message": "Friendship removed."}.to_json
	end
	
	private
	def user_not_found
		error 404, {error: "User not found"}.to_json
	end
end
