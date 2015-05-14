class CreateInvitations < ActiveRecord::Migration
  def change
  	create_table :invitations do |t|
     t.string :user_id 
     t.integer :event_id
     t.string :sender_id
     t.integer :reply, default: 0 #0 => Pending Invitation, 1 => Accepted Invitation, 2 => YOU'VE BEEN REJECTED
     end
  end
end
