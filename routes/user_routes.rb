require 'sinatra/base'
require 'sinatra/activerecord'
require_relative "../models/user"

class UserRoutes < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	# set the :check condition that will help in user auth

	# could be re-written as: 
	# set(:check) { |method_name| condition {send method_name}}
	register do
		def check(method_name)
			condition do
				send(method_name)
			end
		end
	end

	# used with the check condition
	helpers do
		def authorized?
			# put FB auth check here
			@user = User.find_by(auth_id: params[:auth_id])
		end
	end

	# create a new user
	post '/' do
		# do validation checks in the model
		user = User.new
		user.first_name = params[:first_name]
		user.last_name = params[:last_name]
		user.auth_id = params[:auth_id]
		user.auth_token = params[:auth_token]
		user.updated_at = Time.now 
		user.visible = true
		user.loc = "POINT(#{params[:long]} #{params[:lat]})"
		user.save
		
		send_response(user, 201)
	end

	# get a user by id
	get '/:auth_id', :check => :authorized? do
		if @user
			send_response(@user, 200)
		else
			not_found
		end
	end

	# update a user
	put '/:auth_id' , :check => :authorized? do
		if @user
			@user.first_name = params[:first_name] if params[:first_name]
			@user.last_name = params[:last_name] if params[:last_name]
			@user.visible = params[:visible]
			@user.loc = "POINT(#{params[:long]} #{params[:lat]})"
			@user.save
			send_response(@user, 200)
		else
			not_found
		end
	end


	# remove a user
	delete '/:auth_id', :check => :authorized?  do
		if @user
			@user.destroy
			send_response(@user, 200)
		else
			not_found
		end
	end

	get '/:auth_id/friends', :check => :authorized? do
		user = User.find_by_id(params[:auth_id])
		if user
			user.get_friends(500000000000).to_json
		else
			user_not_found
		end
	end

	not_found do
		status 404
		{error: "User not found."}.to_json
	end


	private
	def send_response(user, status)
		halt 400, user.errors.to_json if user.errors.any?

		user.to_json(only: [:first_name, :last_name, :auth_id])
	end
			
end
