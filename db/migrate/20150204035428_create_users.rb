class CreateUsers < ActiveRecord::Migration
	def up
		create_table :users do |t|
			t.string :first_name
			t.string :last_name
			t.string :email
			t.boolean :visible
			t.datetime :updated_at
			t.point :loc, geographic: true
		end
	end

	def down
		drop_table :users
	end
end
