class AddScheduleUrlToConference < ActiveRecord::Migration
  def self.up
    add_column :conferences, :schedule_url, :string
  end

  def self.down
    remove_column :conferences, :schedule_url
  end
end
