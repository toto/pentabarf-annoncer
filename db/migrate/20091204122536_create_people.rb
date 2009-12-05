class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :name
      
      t.timestamps
    end
    
    create_table :events_people, :id => false, :force => true do |t|
      t.integer :event_id
      t.integer :person_id
    end
  end

  def self.down
    drop_table :events_people
    drop_table :people
  end
end
