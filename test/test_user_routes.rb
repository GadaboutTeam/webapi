require_relative './../routes/user_routes'
require_relative './../models/user'
require 'minitest/autorun'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class UserRoutesTest < Minitest::Test
	include Rack::Test::Methods
	
	def app
		UserRoutes
	end

	def setup	
		User.delete_all
		User.create(username: "Joe", auth_id: "1234567890", auth_token: "super_secret_token")
	end


	def test_valid_user_post
		post '/', params = {username: "Jacob",
					auth_id: "0123456789", auth_token: "CAAFzdvnmDoQBAOMSOaTpAW13ysrm4vAUtZAvCOIq0KCcO9BWducNZAeJlyZAbIYzLZAB2G9LBMYZCZCWcuIwSZCBkVxqfTZAGYuZCZAfsimwQOxum8QUGxvogOZAQQEz6rlJrIE9cAN09VNGEzYg5n8CsixDEi3JJ7a7LbBzEj2aHGVlOH6A1Semy46Cy9mOhDu3iN40ThqQ80lJKi7xHvDA56d"}	

		assert last_response.ok?
		attributes = JSON.parse(last_response.body)
		assert_equal "Jacob", attributes["username"]
		# get '/0123456789'
		# attributes = JSON.parse(last_response.body)
		# assert_equal "Jacob", attributes["username"]
		# assert_equal "0123456789", attributes["auth_id"]
	end

	def test_invalid_user_post
		# check that it fails when not given auth details
		post '/', params = {username: "Jacob"}
		assert_equal 400, last_response.status

		# check that it fails when auth_id is already in use
		post '/', params = {username: "Jacob",
                                        auth_id: "1234567890", auth_token: "super_secret_auth_token"}
		assert_equal 400, last_response.status
	end

	def test_user_update
		put '/1234567890', params = {username: "Jack"}
		assert last_response.ok?
		attributes = JSON.parse(last_response.body)
		assert_equal "Jack", attributes["username"]
	end

	def test_delete_existing_user
		delete '/1234567890'
		assert last_response.ok?
	end

end
