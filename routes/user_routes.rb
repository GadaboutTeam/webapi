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
			# put auth check here
			if User.verify_credentials(params[:auth_token], params[:auth_id])
				@user = User.find_by(auth_id: params[:auth_id])
			else
				halt 400
			end
		end
	end

	# create a new user
	post '/' do
		# do validation checks in the model
		if User.verify_credentials(params[:auth_token], params[:auth_id])
			user = User.new
			user.username = params[:username]
			user.auth_id = params[:auth_id]
			user.auth_token = params[:auth_token]
			user.device_id = params[:device_id]
#			user.phone_number = params[:phone_number]
			user.updated_at = Time.now 
			user.visible = true
			user.loc = "POINT(#{params[:long]} #{params[:lat]})"
			user.save

			send_response(user, 201)
		else
			halt 400
		end
	end

	# get a user by id
#	get '/:auth_id', :check => :authorized? do
#		if @user
#			send_response(@user, 200)
#		else
#			not_found
#		end
#	end

	# update a user
	put '/:auth_id' , :check => :authorized? do
		if @user
			@user.username = params[:username] if params[:username]
			@user.device_id = params[:device_id] 
			@user.phone_number = params[:phone_number]
			@user.visible = params[:visible]
			@user.loc = "POINT(#{params[:long]} #{params[:lat]})"
			@user.save
			send_response(@user, 200)
		else
			not_found
		end
	end

	put '/login' do
		user = User.find_by_id(params[:auth_id])
		if user && User.verify_credentials(params[:auth_token], params[:auth_id])
			user.auth_token = params[:auth_token]
			user.save

			send_response(user, 200)

		else
			halt 400
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
	def send_response(user, stat)
puts "*********", user.errors.full_messages if user.errors.any?
		halt 400, user.errors.to_json if user.errors.any?

		status stat
		user.to_json(only: [:username])
	end
			
end
