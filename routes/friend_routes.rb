require 'sinatra/base'
require 'sinatra/activerecord'
require_relative "../models/user"

class FriendRoutes < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	get '/:id' do
		user = User.find_by_id(params[:id])
		if user
			user.get_friends(500000).to_json
		else
			user_not_found
		end
	end

	post '/:user_id/:friend_id' do
		user = User.find_by_id(params[:id])
		friend = User.find_by_id(params[:id])

		if friend.invited? user
			friend.approve user
		else
			user.invite friend
		end
		{"message": "Friendship sent."}.to_json
	end

	delete '/:user_id/:friend_id' do
		user = User.find_by_id(params[:id])
		friend = User.find_by_id(params[:id])
		user.remove_friendship friend
		{"message": "Friendship removed."}.to_json
	end

	private
	def user_not_found
		error 404, {error: "User not found"}.to_json
	end
end
