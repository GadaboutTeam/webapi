class CreateUsers < ActiveRecord::Migration
	def up
		create_table :users do |t|
			t.string :first_name
			t.string :last_name
			t.string :auth_id
			t.text :auth_token
			t.boolean :visible
			t.datetime :updated_at
			t.point :loc, geographic: true
		end
	end

	def down
		drop_table :users
	end
end
