class AddEndTimeToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime
    remove_column :events, :duration
    add_column :events, :duration, :integer
  end

  def self.down
    remove_column :events, :duration
    add_column :events, :duration, :time
    remove_column :events, :end
    remove_column :events, :start_time
  end
end
