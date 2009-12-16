class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  before_filter :find_room
  before_filter :find_current_event
  
  def index
    respond_to do |format| 
      format.html
      format.json do 
        limit = params[:limit] || 5
        limit = limit.to_i        
        @events =  @room.events.for_day_in_conference(Time.now.to_date, @conference).future.all(:order => 'start_time ASC', 
                                                                                                :include => :people,
                                                                                                :limit => limit)
        render(:text => @events.to_json(:methods => [:human_start_time, :js_date])) 
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
    @room = Room.find(params[:room_id])
    @other_rooms = Room.without_room(@room)
  end
  
  def find_current_event
    #@current_event = @room.events.for_date(Time.now)    
  end  
end
