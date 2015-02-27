require 'sinatra/base'
require 'sinatra/activerecord'
require_relative "../models/user"

class UserRoutes < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	# create a new user
	post '/' do
		user = User.find_by_email(params[:email])
		if user
			error 400, {error: "Email already in use."}.to_json
		else
			user = User.new
			user.first_name = params[:first_name]
			user.last_name = params[:last_name]
			user.email = params[:email]
			user.updated_at = Time.now 
			user.visible = params[:visible]
			user.loc = "POINT(#{params[:long]} #{params[:lat]})" 
			user.save
			user.to_json
		end
	end

	# get a user by id
	get '/:id' do
		user = User.find_by_id(params[:id])
		if user
			user.to_json#(except: "auth_token")
		else
			user_not_found
		end
	end

	# update a user
	put '/:id' do
		user = User.find_by_id(params[:id])
		if user
			user.update_attributes(JSON.parse(params.read))
			user.to_json
		else
			user_not_found
		end
	end

	# remove a user
	delete '/:id' do
		user = User.find_by_id(params[:id])
		if user
			user.destroy
			user.to_json
		else
			user_not_found
		end
	end

	# get the friends of a user
	get '/:id/friends' do
		user = User.find_by_id(params[:id])
		if user
			user.friends.to_json
		else
			user_not_found
		end
	end
	
	private
	def user_not_found
		error 404, {error: "User not found."}.to_json
	end
end
