require 'sinatra/activerecord'
require 'grocer'

class Event < ActiveRecord::Base
	has_many :invitations
	#has_many :attendees,  -> { where(invitations: {reply: 1})}, through: :invitations,  primary_key: "user_id", foreign_key: "auth_id", class_name: "User"


	def attendees
		User.joins('INNER JOIN invitations ON invitations.user_id = users.auth_id').joins('INNER JOIN events ON invitations.event_id = events.id').where("events.id = ? AND invitations.reply = 1", self.id).select("username, auth_id, loc")
	end
end
