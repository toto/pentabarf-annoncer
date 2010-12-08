require 'nokogiri'

class ImportJob < Struct.new(:conference)
  def perform
#    conf = Conference.find_or_create_by_schduel_url(self.schedule_xml_url)
    Conference.transaction do
      self.conference.update_attribute(:import_running, true)
      Event.import_from_pentabarf_url(self.conference.schedule_url)      
      self.conference.update_attribute(:import_running, false)      
    end        
  end    
end