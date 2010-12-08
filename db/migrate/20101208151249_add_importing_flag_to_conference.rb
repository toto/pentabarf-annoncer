class AddImportingFlagToConference < ActiveRecord::Migration
  def self.up
    add_column :conferences, :import_running, :boolean, :default => false
  end

  def self.down
    remove_column :conferences, :import_running
  end
end
