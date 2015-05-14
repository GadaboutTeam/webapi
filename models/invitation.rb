require 'sinatra/activerecord'
require 'grocer'

class Invitation < ActiveRecord::Base
	belongs_to :event
	belongs_to :user
	# after_save do |invitation|
	# 	send_invitations(invitation)
	# end


	def send_invitations
		@pusher = Grocer.pusher(
			certificate: File.absolute_path("../api/support_files/pushcert.pem"),
			retries:     3
		)

		
		# puts "user_id #{user_id} event_id #{event_id}"
		user = User.find_by(auth_id: user_id)
		creator = User.find_by(auth_id: sender_id)
		event = Event.find(event_id)
		# puts "\n\n\n\n\n PUSHING NOTIFICATION TO #{creator.inspect} \n\n\n\n\n"
		notification = Grocer::Notification.new(
				device_token: user.device_id,
				alert: "#{creator.username} said: \"#{event.title}\"",
				custom: { invitation: self.as_json }

			)
		@pusher.push(notification)	
	end
end
