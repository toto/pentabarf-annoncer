class Backend::ConferencesController < Backend::BackendController
  def index
    @conferences = Conference.all(:order => 'title')
  end

  def new
    @conference = Conference.new
  end
  
  def create
    @conference = Conference.new(params[:conference])
    
    if @conference.save
      flash[:notice] = "Conference created"
      redirect_to backend_conference_import_path(@conference) and return
    end
    
    render(:action => :new)
  end

  def edit
    @conference = Conference.find(params[:id])    
  end
  
  def update
    @conference = Conference.find(params[:id])    
    
    if @conference.update_attributes(params[:conference])
      flash[:notice] = "Conference updated"
      redirect_to backend_conference_import_path(@conference) and return
    end
    
    render(:action => :edit)    
  end


  def destroy
    @conference = Conference.find(params[:id])
    @conference.destroy
    flash[:notice] = "Deleted #{@conference.title}"
    redirect_to backend_conferences_path and return
  end
end
