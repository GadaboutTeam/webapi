class CreateFriendships < ActiveRecord::Migration
	def up
		create_table :friendships do |t|
			t.integer :user_id
			t.integer :friend_id
			t.integer :blocker_id, default: nil
			t.boolean :accepted, default: false
		end

	#	add_index :friendships, [:user_id, :friend_id], unique: true
	end

	def down
		drop_table :friendships
	end
end
