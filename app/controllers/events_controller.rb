class EventsController < ApplicationController
  before_filter :find_room
  before_filter :find_current_event
  def index
    @events = @room.events#.al(:page => params[:page],
                          #          :order => 'start_time ASC')
  end
  
  def show
    @event = Event.find(params[:id])
    
    respond_to do |format|
      format.json
    end
  end
  
  before_filter :find_current_event
  protected
  def find_room
    @room = Room.find(params[:room_id])
  end
  
  def find_current_event
    @current_event = @room.events.for_date(Time.now)    
  end  
end
