require 'sinatra/activerecord'

class Friendship < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, class_name: "User", foreign_key: "friend_id"
	

	def self.connect(user_id, friend_id)
		user_to_friend_connection = Friendship.find_by(user_id: user_id, friend_id: friend_id)
		friend_to_user_connection = Friendship.find_by(user_id: friend_id, friend_id: user_id)
		unless user_to_friend_connection
			Friendship.create(user_id: user_id, friend_id: friend_id)
		end

		if friend_to_user_connection
			#update both
			Friendship.transaction do
				user_to_friend_connection.update(accepted: true)
				friend_to_user_connection.update(accepted: true)
			end
		end
	end

	def self.delete(user_id, friend_id)
		Friendship.transaction do
			Friendship.where(user_id: user_id, friend_id: friend_id).destroy_all
			Friendship.where(user_id: friend_id, friend_id: user_id).destroy_all
		end
	end

end
