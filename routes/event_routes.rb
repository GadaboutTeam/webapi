require 'sinatra/base'
require 'sinatra/activerecord'
require 'json'
require_relative '../models/event'
require_relative '../models/user'
require_relative '../models/invitation'

class EventRoutes < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	get '/' do
		puts params.inspect
		user = User.find_by(auth_id: params[:auth_id])
		if user
			# puts "\n\n\n\n #{user.inspect}\n\n\n\n"
			events = user.events.where("start_time > ?", Time.now.utc)
			# invitations = user.invitations
			# puts invitations.inspect

			send_response(events, 200)
		else 
			halt 400
		end
	end

	post '/' do 
		if User.verify_credentials(params[:auth_token], params[:auth_id])
			start_time = DateTime.parse(params[:start_time])
			end_time = DateTime.parse(params[:end_time])
			users_array = params[:users_array].scan(/\d+/)

			creator =  User.find_by(auth_id: params[:auth_id])
			users = User.where(auth_id: users_array)
			users.push(creator)
			event = Event.create(title: params[:title], active: params[:active], start_time: start_time, end_time: end_time)

			users.each do |user|
				invitation = Invitation.create(user_id: user.auth_id, sender_id: creator.auth_id, event_id: event.id)
				invitation.send_invitations unless invitation.user_id == invitation.sender_id
			end
			

			send_response(event, 201)
		else
			halt 400
		end
	end

	get '/:event_id/attendees' do 
		event = Event.find(params[:event_id])
		attendees = event.attendees

		send_response(attendees, 200)
	end

	get '/:event_id/invitations' do 
		invitations = Invitation.where(event_id: params[:event_id])

		# puts "\n\n\n\n #{invitations.to_json}\n\n\n\n"
		puts invitations
		send_response(invitations, 200)
	end


	post '/:event_id/reply' do 
		invitation = Invitation.find_by(user_id: params[:auth_id], event_id: params[:event_id])
		if invitation
			invitation.reply = params[:reply]
			invitation.save

			send_response(invitation, 200)
		else 
			halt 400
		end
	end

	private
	def send_response(object, stat)
# puts "*********", object.errors.full_messages if object.errors.any?
# 		halt 400, object.errors.to_json if object.errors.any?

		status stat
		object.to_json
	end
end
