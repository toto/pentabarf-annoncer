class AddBlackoutToConference < ActiveRecord::Migration
  def self.up
    add_column :conferences, :blackout, :boolean, :default => false
  end

  def self.down
    remove_column :conferences, :blackout
  end
end
