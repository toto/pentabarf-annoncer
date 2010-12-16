class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.date :date
      t.time :start
      t.time :duration
      t.integer :room_id  
      t.string :title
      t.string :subtitle
      t.string :track 
      t.string :type
      t.string :language
      t.text :abstract
      t.text :description 
      
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
