class CreateConferences < ActiveRecord::Migration
  def self.up
    create_table :conferences do |t|
      t.string :title
      t.string :subtitle
      t.string :venue
      t.string :city
      t.time :day_change
      t.timestamps
    end
    add_column :events, :conference_id, :integer
  end

  def self.down
    remove_column :events, :column_name
    drop_table :conferences
  end
end
