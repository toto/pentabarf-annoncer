class AddConferenceToRoom < ActiveRecord::Migration
  def self.up
    add_column :rooms, :conference_id, :integer
  end

  def self.down
    remove_column :rooms, :conference_id
  end
end
