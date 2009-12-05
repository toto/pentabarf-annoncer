# == Schema Information
#
# Table name: conferences
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  subtitle   :string(255)
#  venue      :string(255)
#  city       :string(255)
#  day_change :time
#  created_at :datetime
#  updated_at :datetime
#

class Conference < ActiveRecord::Base
  has_many :events
  
  def begin_time(date=Time.now.to_date)
    date.to_datetime.at_beginning_of_day + self.day_change.hour.hours + self.day_change.min.minutes
  end
  
  def end_time(date=Time.now.to_date)
    date.to_datetime.tomorrow + self.day_change.hour.hours + self.day_change.min.minutes
  end
end
