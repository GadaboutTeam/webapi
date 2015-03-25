require_relative './../routes/friend_routes'
require_relative './../models/friendship'
require_relative './../models/user'
require 'minitest/autorun'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class FriendRoutesTest < Minitest::Test
	include Rack::Test::Methods

	def app
		FriendRoutes
	end

	def setup
		Friendship.delete_all
		User.delete_all
		@user1 = User.create(username: "Joe", auth_id: "1234567890", auth_token: "super_secret_token")
		@user2 = User.create(username: "Someone", auth_id: "0123456778", auth_token: "even_more_super_secret_token")
	end

	def test_friendship_post
		post '/', params = {auth_id: @user1.auth_id, friend_id: @user2.auth_id}
		assert last_response.ok?
		assert_includes last_response.body, "Friendship sent"
	end

	def test_friendship_delete
		delete '/', params = {auth_id: @user1.auth_id, friend_id: @user2.auth_id}
		assert last_response.ok?
		assert_includes last_response.body, "Friendship removed"
	end
end
