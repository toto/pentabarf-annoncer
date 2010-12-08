class Backend::ConferenceImportController < Backend::BackendController
  before_filter :find_conference
  
  def show
    
  end
  
  def create
    unless @conference.import_running?
      @conference.update_attribute(:import_running, true)
      Delayed::Job.enqueue(ImportJob.new(@conference)) 
    end
    
    redirect_to backend_conference_import_path(@conference) and return    
  end
  
  def destroy
    if @conference.import_running?
      @conference.update_attribute(:import_running, false)
#      Delayed::Job.enqueue(ImportJob.new(@conference)) 
    end
      
    
    redirect_to backend_conference_import_path(@conference) and return
  end


  protected
  def find_conference
    @conference = Conference.find(params[:conference_id])
  end
end
