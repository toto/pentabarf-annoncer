class AddMotto < ActiveRecord::Migration
  def self.up
    add_column :conferences, :motto, :string
  end

  def self.down
    remove_column :conferences, :motto
  end
end
