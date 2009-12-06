class EventsController < ApplicationController
  before_filter :find_room
  before_filter :find_current_event
  
  def index
    events =  Event.for_day_in_conference(Time.now.to_date, @conference).future.all(:order => 'start_time ASC')
    
    @events = events.group_by(&:room)

    Room.all.each{|r| @events[r] ||= []}

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
  end
  
  def find_current_event
    #@current_event = @room.events.for_date(Time.now)    
  end  
end
