# == Schema Information
#
# Table name: rooms
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Room < ActiveRecord::Base
  has_many :events
  
  scope :for_conference, lambda {|conference|
    {:conditions => {:conference_id => conference.id}}
  }
  
  scope :without_room, lambda {|room|
    {:conditions => ['id <> ?', room.id],
     :order => 'name ASC'}
  }
end
