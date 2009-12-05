# == Schema Information
#
# Table name: people
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Person < ActiveRecord::Base
  has_and_belongs_to_many :events, :join_table => "events_people", :foreign_key => "person_id"
end
