class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  before_filter :find_room

  
  def index
    limit = params[:limit] || 5
    limit = limit.to_i      
    @events = @room.events.this_day.future.all(:order => 'start_time ASC', 
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
    @other_rooms = Room.without_room(@room)
  end
  
  
end
