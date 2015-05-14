class CreateEvents < ActiveRecord::Migration
  def change
     create_table :events do |t|
     t.string :title
     t.boolean :active
     t.datetime :start_time, index: true
     t.datetime :end_time
     # t.point :location, default: nil
     end
  end 
end
