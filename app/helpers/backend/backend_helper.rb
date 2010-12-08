module Backend::BackendHelper
  def navigation_list
    [['Conferences', backend_conferences_path]]
  end
  
  def navigation
    str = ''
    flash.each do |k,v|
      str << %Q{<p class="notification #{k}">#{v}</p>}      
    end
    str << %Q{<ul class="navigation">}
    str << navigation_list.collect{|i| "<li>#{link_to(i.first, i.last)}</li>"}.join(' ')
    str << %Q{</ul>}    
  end
  
end

