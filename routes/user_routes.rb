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
			@user = User.find_by(fb_id: params[:id])
			# put FB auth check here
		end
	end

	# create a new user
	post '/' do
		# do validation checks in the model
		user = User.new
		user.first_name = params[:first_name]
		user.last_name = params[:last_name]
		user.fb_id = params[:fb_id]
		user.auth_token = params[:auth_token]
		user.email = params[:email]
		user.updated_at = Time.now 
		user.visible = true
		user.save

		send_response(@user, 201)
	end

	# get a user by id
	get '/:id', :check => :authorized? do
		if @user
			send_response(@user, 200)
		else
			not_found
		end
	end

	# update a user
	put '/:id' , :check => :authorized? do
		if @user
			@user.first_name = params[:first_name] if params[:first_name]
			@user.last_name = params[:last_name] if params[:last_name]
			@user.email = params[:email] if params[:email]
			@user.visible = params[:visible]
			@user.loc = "POINT(#{params[:long]} #{params[:lat]})"
			@user.save
			send_response(@user, 200)
		else
			not_found
		end
	end


	# remove a user
	delete '/:id', :check => :authorized?  do
		if @user
			@user.destroy
			send_response(@user, 200)
		else
			not_found
		end
	end

	not_found do
		status 404
		{error: "User not found."}.to_json
	end


	private
	def send_response(user, status)
		halt 400, user.errors.to_json if user.errors.any?

		user.to_json(only: [:first_name, :last_name, :fb_id])
	end
			
end
