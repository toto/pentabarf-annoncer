# == Schema Information
#
# Table name: events
#
#  id            :integer         not null, primary key
#  date          :date
#  start         :time
#  room_id       :integer
#  title         :string(255)
#  subtitle      :string(255)
#  track         :string(255)
#  type          :string(255)
#  language      :string(255)
#  abstract      :text
#  created_at    :datetime
#  updated_at    :datetime
#  conference_id :integer
#  start_time    :datetime
#  end_time      :datetime
#  duration      :integer
#

require 'open-uri'

class Event < ActiveRecord::Base
  MAX_OTHER_ROOM_EVENTS = 2
  MAX_THIS_ROOM_EVENTS = 5
  REFRESH_TIME = (30.seconds.to_i * 1000)
  PAGE_RELOAD_TIME = (30.minutes.to_i * 1000)
  
  named_scope :for_day_in_conference, lambda {|date, conference|
    {:conditions => ["(start_time BETWEEN ? AND ?)",
                     conference.begin_time(date),
                     conference.end_time(date)]}
  }

  named_scope :after, lambda {|time|
    {:conditions => ['(end_time >= ?)', time]}
  }

  named_scope :future, {:conditions => ['(end_time >= ?)', Time.zone.now]}
  named_scope :in_room, lambda {|room|
    {:conditions => ['room_id = ?', room.id]}  
  }

  
  named_scope :this_day, lambda {
    conference = Conference.first
    date = if Time.zone.now < conference.begin_time(Time.zone.now.to_date)
      Time.zone.now.yesterday.to_date
    else
      Time.zone.now.to_date
    end

    begin_time = conference.begin_time(date)
    end_time = conference.end_time(date)
    
    {:conditions => ["(start_time BETWEEN ? AND ?)",
                     conference.begin_time(date),
                     conference.end_time(date)]}    
    
  }
  
  
  has_and_belongs_to_many :people, :join_table => "events_people", :foreign_key => "event_id"
  belongs_to :room
  belongs_to :conference
  
  validates_presence_of :date
  validates_presence_of :start
  before_save :update_end_date_and_start_date

  validates_numericality_of :duration
  
  def to_s
    "Event: '#{title}' (#{date} starting #{start_time})"
  end
  
  def duration=(value)
    if value =~ /\A\d\d\:\d\d\Z/
      parts = value.split(':')
      value = parts.first.to_i.hours.to_i + parts.first.to_i.minutes.to_i
    end
    write_attribute(:duration, value)
  end
  
  def same_conference_day?
    (self.start_time >= (self.conference.begin_time)) &&
    (self.start_time <= (self.conference.end_time))
  end
  
  class <<self
    def import_from_pentabarf_xml(raw_xml_or_io)
      xml  = Nokogiri::XML(raw_xml_or_io)
      
      Conference.transaction do
        # Import Conference
        conference = nil
        xml.xpath("//conference").each do |xml_conference|
          
          conference = Conference.find_or_create_by_title(xml_conference.xpath("//title").first.content)
          xml_conference.children.each do |child|
            conference.send("#{child.node_name}=", child.content) if conference.respond_to?("#{child.node_name}=")
          end
          conference.save!
        end
        
        xml.xpath("//event").each do |xml_event|

          date = Date.civil(*xml_event.parent.parent.attributes['date'].to_s.split('-').collect(&:to_i))
          event_id = xml_event.attributes['id'].to_s
          event = Event.find_by_event_id(event_id) 
          event = Event.new(:event_id => event_id) unless event
          event.date = date
          xml_event.children.each do |child|
            if Event.column_names.include?(child.node_name)
              event.send("#{child.node_name}=", child.content) 
            else
              case child.node_name
              when 'persons'
                child.children.each do |person_node|
                  person = Person.find_by_id(person_node.attributes['id'].to_s.to_i) || Person.new
                  person.name = person_node.content
                  event.people << person
                end
              when 'room'
                event.room = Room.find_or_create_by_name(child.content)
              end
            end
          end
          event.conference = conference
          event.save!
          Rails.logger.info "Imported event #{event} (#{event.inspect})"
        end        
        
      end
    end
  
    def import_from_pentabarf_url(url)
      open(url) do |fd|
        import_from_pentabarf_xml(fd)
      end
    end
    
    def inheritance_column
      'some_thing_else_so_i_can_use_type_as_a_regular_column'
    end    

    def make_some_events_current
      start_date = Event.first.date
      
      Event.find(:all, :conditions => ['date = ?', start_date]).each do |event|
        event.date = Time.zone.now.to_date
        event.start_time = Time.now
        event.save
      end
      
      1.upto(3) do |i|
        Event.find(:all, :conditions => ['date = ?', start_date + i.days]).each do |event|
          event.date = Time.zone.now.to_date#  + i.day
          event.start_time = i.minutes.from_now
          event.save        
        end        
      end
    end    
  end  
  
  def human_start_time
    I18n.l(self.start_time, :format => :time)
  end
  
  def js_date
    self.start_time.rfc2822
  end
  
  def current
    current?
  end
    
  def current?
    time = Time.zone.now
    (self.start_time <= time && self.end_time > time)
  end  

  protected
  def update_end_date_and_start_date
    hour, min = self.start.hour, self.start.min
    if hour == 0 && min == 0
      hour, min = 23, 59 # HACK: fix date change bug
    end
    self.start_time = Time.zone.local(self.date.year, 
                               self.date.month, 
                               self.date.day,
                               hour,
                               min)
    Rails.logger.debug "Set Start Time: #{self.start_time} from #{[self.date.year, self.date.month, self.date.day, hour, min].inspect}"
    
    self.end_time = self.start_time + self.duration
  end
end
