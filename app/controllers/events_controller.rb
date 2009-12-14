class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  before_filter :find_room
  before_filter :find_current_event
  
  def index
    events =  Event.for_day_in_conference(Time.now.to_date, @conference).future.all(:order => 'start_time ASC')
    
    @events = events.group_by(&:room)

    Room.all.each{|r| @events[r] ||= []}
    
    respond_to do |format| 
      format.html
      format.json { render(:json => @events) }      
      format.js do
        render(:update) do |page|
          @event.values.flatten.each do |event|
            
            page << %Q{
              var current_event_ids = $(".")
              
              if($(''))
            }
          end
          
          page << %Q{
            
            $(".this_room li").each(function(i){
              this.style.color = 'blue'
            });
            $(".other_rooms li").each(function(i){
              this.style.color = 'red'
            });            
          }
        end
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
    @rooms = Room.all
  end
  
  def find_current_event
    #@current_event = @room.events.for_date(Time.now)    
  end  
end
