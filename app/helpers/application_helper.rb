# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def jquery(*args, &block)
    html_options = args.extract_options!
    content = ''.tap do |js|
      js << '(function($){' 
      if block
        js << capture(&block)
      else
        js << args.first
      end
      js << '})(jQuery);'
    end
    tag = content_tag(:script, javascript_cdata_section(content), html_options.merge(:type => Mime::JS, :defer => 'defer'))


      tag

  end

end
