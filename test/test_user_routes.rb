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
		User.create(first_name: "Joe", last_name: "Test", email: "test@example.com", fb_id: "12345", auth_token: "super_secret_token")
	end


	def test_valid_user_post_and_get
		post '/', params = {first_name: "Jacob", last_name: "Murphy", email: "murphorum@gmail.com", 
					fb_id: "100000179320442", auth_token: "CAAFzdvnmDoQBAOMSOaTpAW13ysrm4vAUtZAvCOIq0KCcO9BWducNZAeJlyZAbIYzLZAB2G9LBMYZCZCWcuIwSZCBkVxqfTZAGYuZCZAfsimwQOxum8QUGxvogOZAQQEz6rlJrIE9cAN09VNGEzYg5n8CsixDEi3JJ7a7LbBzEj2aHGVlOH6A1Semy46Cy9mOhDu3iN40ThqQ80lJKi7xHvDA56d"}	

		assert last_response.ok?

		get '/100000179320442'
		attributes = JSON.parse(last_response.body)
		assert_equal "Jacob", attributes["first_name"]
		assert_equal "Murphy", attributes["last_name"]
		assert_equal "100000179320442", attributes["fb_id"]
	end

	def test_invalid_user_post
		# check that it fails when not given a last name
		post '/', params = {first_name: "Jacob", email: "testemail@example.com"}
		assert_equal 400, last_response.status

		# check that it fails when email is already in use
		post '/', params = {first_name: "Jacob", last_name: "Murphy", email: "test@example.com",
                                        fb_id: "100000179320442", auth_token: "super_secret_auth_token"}
		assert_equal 400, last_response.status
	end

	def test_user_update_and_get
		put '/12345', params = {first_name: "Jack", email: "jcmurphy@brandeis.edu"}
		assert last_response.ok?
                get '/12345'
		attributes = JSON.parse(last_response.body)
		assert_equal "Jack", attributes["first_name"]
	end

	def test_delete_existing_user
		delete '/12345'
		assert last_response.ok?
		
                get '/12345'
		assert_equal 404, last_response.status
	end

end
