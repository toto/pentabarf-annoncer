class Backend::EventsController < Backend::BackendController

      
  def index
    @events = Event.all(:order => 'title')
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end
end
