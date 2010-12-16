class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  before_filter :find_room

  
  def index
    limit = params[:limit] || 5
    limit = limit.to_i      
    time = Time.zone.now
    
    
    if defined? SIMULATE_CONGRESS_DAY
      time = Time.utc(Time.now.year, 12, 26 + SIMULATE_CONGRESS_DAY, Time.now.hour, Time.now.min)
    end
    
    @events = @room.events.this_day.after(time).all(:order => 'start_time ASC', 
                                                             :limit => limit)
      

    respond_to do |format| 
      format.html
      format.json do 
        render(:text => @events.to_json(:methods => [:human_start_time, :js_date, :current])) 
      end      
    end
  end
  
  def show
    @event = Event.find(params[:id])
    
    respond_to do |format|
      format.json
    end
  end
  
  protected
  def find_room
    @room = Room.find_by_id(params[:room_id]) || Room.find_by_name(params[:room_id])
    
    logger.error(@room.events.inspect)
    
    @other_rooms = Room.without_room(@room).for_conference(@conference)
  end
  
  
end
